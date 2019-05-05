sub init()
    m.top.itemComponentName = "ListPoster"
    m.top.content = getData()

    m.top.rowFocusAnimationStyle = "floatingFocus"
    'm.top.vertFocusAnimationStyle = "floatingFocus"

    m.top.showRowLabel = [false]

    updateSize()

    m.top.setfocus(true)
end sub

sub updateSize()
    m.top.numrows = 1
    m.top.rowSize = 5

    dimensions = m.top.getScene().currentDesignResolution

    border = 75
    m.top.translation = [border, border + 115]

    textHeight = 75
    ' Do we decide width by rowSize, or rowSize by width...
    itemWidth = (dimensions["width"] - border*2) / m.top.rowSize
    itemHeight = itemWidth * 1.5 + textHeight

    m.top.visible = true

    ' size of the whole row
    m.top.itemSize = [dimensions["width"] - border*2, itemHeight]
    ' spacing between rows
    m.top.itemSpacing = [ 0, 10 ]

    ' size of the item in the row
    m.top.rowItemSize = [ itemWidth, itemHeight ]
    ' spacing between items in a row
    m.top.rowItemSpacing = [ 0, 0 ]
end sub

function setData()
    movieData = m.top.movieData
    rowsize = m.top.rowSize

    n = movieData.items.count()

    ' Test for no remainder
    if int(n/rowsize) = n/rowsize then
        m.top.numRows = n/rowsize
    else
        m.top.numRows = n/rowsize + 1
    end if

    m.top.content = getData()
end function

function getData()
    if m.top.movieData = invalid then
        data = CreateObject("roSGNode", "ContentNode")
        return data
    end if

    movieData = m.top.movieData
    rowsize = m.top.rowSize
    data = CreateObject("roSGNode", "ContentNode")
    for rownum=1 to m.top.numRows
        row = data.CreateChild("ContentNode")
        for i=1 to rowsize
            index = (rownum - 1) * rowsize + i
            if index > movieData.items.count() then
                exit for
            end if
            row.appendChild(movieData.items[index-1])
        end for
    end for
    return data
end function

function onKeyEvent(key as string, press as boolean) as boolean
    if not press then return false

    if key = "down" and (m.top.itemFocused + 1) = m.top.content.getChildCount()
        m.top.getScene().findNode("pager").setFocus(true)
        m.top.getScene().findNode("pager").getChild(0).setFocus(true)
        return true
    else if key = "options"
        options = m.top.getScene().findNode("options")
        list = options.findNode("panelList")

        options.visible = true
        list.setFocus(true)

        return true
    end if

    return false
end function