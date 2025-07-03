fn lightsAreIdentical l1 l2 =
(
    classOf l1 == classOf l2 and
    l1.lightShape == l2.lightShape and
    l1.color == l2.color and
    l1.multiplier == l2.multiplier and
    l1.visibleDirect == l2.visibleDirect and
    l1.visibleReflections == l2.visibleReflections and
    l1.visibleRefractions == l2.visibleRefractions and
    l1.doubleSided == l2.doubleSided and
    l1.directionality == l2.directionality and
    l1.useTarget == l2.useTarget and
    l1.occludeOtherLights == l2.occludeOtherLights and
    l1.castShadows == l2.castShadows and
    l1.includeExcludeList == l2.includeExcludeList and
    l1.width == l2.width and
    l1.height == l2.height and
    l1.radius == l2.radius
)

fn instanceReplace oldObj newObj =
(
    local pos = oldObj.position
    local rot = oldObj.rotation
    local scale = oldObj.scale
    local parent = oldObj.parent

    delete oldObj
    local newInstance = instance newObj
    newInstance.position = pos
    newInstance.rotation = rot
    newInstance.scale = scale
    if isValidNode parent do parent.appendChild newInstance
)

fn instanceSimilarCoronaLights =
(
    local lights = getClassInstances CoronaLight
    local groups = #()

    for l in lights do
    (
        local matched = false
        for g in groups do
        (
            if lightsAreIdentical l g[1] do
            (
                append g l
                matched = true
                exit
            )
        )
        if not matched do
        (
            append groups #(l)
        )
    )

    for g in groups do
    (
        local master = g[1]
        for i = 2 to g.count do
        (
            instanceReplace g[i] master
        )
    )
)

instanceSimilarCoronaLights()
