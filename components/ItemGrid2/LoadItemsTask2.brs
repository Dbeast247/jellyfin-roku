sub init()
  m.top.functionName = "loadItems"
end sub

sub loadItems()

  results = []

  sort_field = m.top.sortField
  
  if m.top.sortAscending = true then
    sort_order = "Ascending"
  else
    sort_order = "Descending"
  end if

  params = {
    limit: m.top.limit,
    StartIndex: m.top.startIndex,
    parentid: m.top.itemId,
    SortBy: sort_field,
    SortOrder: sort_order,
    recursive: true,
    Fields: "Overview"
  }

  if m.top.ItemType <> "" then
    params.append({ IncludeItemTypes: m.top.ItemType})
  end if

  url = Substitute("Users/{0}/Items/", get_setting("active_user"))
  resp = APIRequest(url, params)
  data = getJson(resp)

  if data.TotalRecordCount <> invalid then
    m.top.totalRecordCount = data.TotalRecordCount
  end if
  
  for each item in data.Items

    tmp = invalid
    if item.Type = "Movie" then
      tmp = CreateObject("roSGNode", "MovieData")
    else if item.Type = "Series" then
      tmp = CreateObject("roSGNode", "SeriesData")
    else if item.Type = "BoxSet" then
      tmp = CreateObject("roSGNode", "CollectionData")
    else
      print "Unknown Type: " item.Type

    end if
  
    if tmp <> invalid then

      tmp.json = item
      results.push(tmp)

    end if
  end for

  m.top.content = results

end sub