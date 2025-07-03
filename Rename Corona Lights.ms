-- ------------- helper compare functions ----------------
fn cmpPosX a b = a.position.x < b.position.x
fn cmpPosY a b = a.position.y < b.position.y
fn cmpPosZ a b = a.position.z < b.position.z

-- ------------- main renamer ----------------------------
fn renameSelectedCoronaLights baseName:"Downlight" startIndex:1 padding:0 sortBy:#none =
(
    local lights = for o in selection where isKindOf o CoronaLight collect o
    if lights.count == 0 do
    (
        messageBox "No Corona lights selected." title:"Rename Corona Lights"
        return undefined
    )

    if sortBy == #x do qsort lights cmpPosX
    if sortBy == #y do qsort lights cmpPosY
    if sortBy == #z do qsort lights cmpPosZ

    -- build number format (no leading %)
	local numFmt = if padding > 0 then ("0" + padding as string + "d") else "d"

    local i = startIndex
    for l in lights do
    (
        l.name = baseName + " " + (formattedPrint i format:numFmt)
        i += 1
    )
)

-- ------------- simple UI --------------------------------
try (destroyDialog ::dlgRenCorona) catch ()
rollout dlgRenCorona "Rename Corona Lights"
(
    editText    edtBase  "Base name:"     text:"Downlight" fieldWidth:120
    spinner     spnStart "Start number:"  type:#integer range:[1,100000,1] fieldWidth:60
    spinner     spnPad   "Zero padding:"  type:#integer range:[0,5,0]      fieldWidth:60
    dropdownList ddlSort "Sort by:"       items:#("None","X","Y","Z") selection:1
    button      btnGo "Rename" width:120

    on btnGo pressed do
    (
        local axis = case ddlSort.selected of
        (
            "X": #x
            "Y": #y
            "Z": #z
            default: #none
        )
        renameSelectedCoronaLights \
            baseName:edtBase.text \
            startIndex:spnStart.value \
            padding:spnPad.value \
            sortBy:axis
        messageBox "Done!" title:"Rename Corona Lights"
    )
)
createDialog dlgRenCorona width:220
