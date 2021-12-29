import std/[httpclient, json, strutils]
const url = "https://api.thegraph.com/subgraphs/name/ensdomains/ens"

proc get_owner(ens: string): string =
    let client = newHttpClient()
    client.headers = newHttpHeaders({ "Content-Type": "application/json" })
    let body = %*{
        "query": "query{domains(where:{name:\"" & toLower(ens) & ".eth\"}){id}}"
    }
    let
        response = client.request(url, httpMethod = HttpPost, body = $body)
        parsed = response.body.parseJson
        elems = parsed["data"]["domains"].getElems

    if len(elems) == 0:
        return "no owner found"
    else:
        return elems[0]["id"].getStr

echo "name,owner"
for line in lines "/in/input.csv":
    echo line & "," & get_owner line