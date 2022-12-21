# functions to read .svg files 
using StructArrays
using EzXML

export ReadPlainSVG


struct Path
    id :: String
    d  :: String
end

struct PathCollection
    width  :: Float64
    height :: Float64
    numP   :: Int64
    paths  :: StructArray{Path}
end

"Reads SVG files:
Tested with Inkscape Inkscape 1.2 (1:1.2.1+202207142221+cd75a1ee6d)
SVG Files must be saved as plain .svg!
"
function ReadPlainSVG(File::String)

    # read svg file file
    svg = root(parsexml(String(read(File))))

    # count numbers of 
    width  = 0
    height = 0
    x0     = 0
    y0     = 0
    i      = 0   

    # get general information
    for node in eachelement(svg)
        if nodename(node) == "g"
            for elem in eachelement(node)  
                if elem.name == "rect" && elem["id"]  == "Reference"
                    width  = parse(Float64,elem["width"])
                    height = parse(Float64,elem["height"])
                    x0     = parse(Float64,elem["x"])
                    y0     = parse(Float64,elem["y"])
                elseif elem.name == "path"   
                        i += 1
                end
            end
        end
    end


    Objects = StructArray{Path}(undef,i)

    # access different paths objects
    j = 0
    for node in eachelement(svg)
        if nodename(node) == "g"
            for elem in eachelement(node)  
                if elem.name == "path"
                    j += 1
                    Objects[j] = Path(elem["id"],elem["d"])
                end
            end
        end
    end

    PathsInfo = PathCollection(width,height,i,Objects)

    return PathsInfo

end


