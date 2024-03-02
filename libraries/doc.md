# EaseTypes

```lua
EaseTypes:
    | "linear"
    | "inQuad"
    | "outQuad"
    | "inOutQuad"
    | "outInQuad"
    | "inCubic "
    | "outCubic"
    | "inOutCubic"
    | "outInCubic"
    | "inQuart"
    | "outQuart"
    | "inOutQuart"
    | "outInQuart"
    | "inQuint"
    | "outQuint"
    | "inOutQuint"
    | "outInQuint"
    | "inSine"
    | "outSine"
    | "inOutSine"
    | "outInSine"
    | "inExpo"
    | "outExpo"
    | "inOutExpo"
    | "outInExpo"
    | "inCirc"
    | "outCirc"
    | "inOutCirc"
    | "outInCirc"
    | "inElastic"
    | "outElastic"
    | "inOutElastic"
    | "outInElastic"
    | "inBack"
    | "outBack"
    | "inOutBack"
    | "outInBack"
    | "inBounce"
    | "outBounce"
    | "inOutBounce"
    | "outInBounce"
```


```lua
string|"inBack"|"inBounce"|"inCirc"|"inCubic "|"inElastic"|"inExpo"|"inOutBack"|"inOutBounce"|"inOutCirc"|"inOutCubic"|"inOutElastic"|"inOutExpo"|"inOutQuad"|"inOutQuart"|"inOutQui...(too long)...|"outSine"
```


---

# EventLib

## __call


```lua
(method) EventLib:__call(...any)
  -> table
```

## __index


```lua
EventLib
```

## __len


```lua
(method) EventLib:__len()
  -> integer
```

## clear


```lua
(method) EventLib:clear()
```

Clears all event

## getRegisteredCount


```lua
(method) EventLib:getRegisteredCount()
  -> integer
```

Returns how much listerners there are.

## invoke


```lua
(method) EventLib:invoke(...any)
  -> table
```

## register


```lua
(method) EventLib:register(func: function, name?: string)
```

Registers an event

## remove


```lua
(method) EventLib:remove(match: string)
```

Removes an event with the given name.

## subscribers


```lua
table
```


---

# GNUI

## newContainer


```lua
function
```

## newLabel


```lua
function
```

## newSprite


```lua
function
```

## utils


```lua
table
```


---

# GNUI.Label

## ANCHOR_CHANGED


```lua
EventLib
```

## Align


```lua
Vector2
```

A vector that is two elements long.

## Anchor


```lua
Vector4
```

A vector that is four elements long.

## AutoWarp


```lua
boolean
```

## CHILDREN_CHANGED


```lua
table
```

## CURSOR_CHANGED


```lua
EventLib
```

## CaptureCursor


```lua
boolean
```

## ChildIndex


```lua
integer
```

## Children


```lua
table<any, GNUI.container|GNUI.element>
```

## ClipOnParent


```lua
boolean
```

## ContainerShift


```lua
Vector2
```

A vector that is two elements long.

## ContainmentRect


```lua
Vector4
```

A vector that is four elements long.

## Cursor


```lua
Vector2?
```

A vector that is two elements long.

## DIMENSIONS_CHANGED


```lua
EventLib
```

## Dimensions


```lua
Vector4
```

A vector that is four elements long.

## FontScale


```lua
number
```

## GrowDirection


```lua
Vector2
```

A vector that is two elements long.

## Hovering


```lua
boolean
```

## LineHeight


```lua
number
```

## MARGIN_CHANGED


```lua
EventLib
```

## MOUSE_ENTERED


```lua
EventLib
```

## MOUSE_EXITED


```lua
EventLib
```

## Margin


```lua
Vector4
```

A vector that is four elements long.

## MinimumSize


```lua
Vector2
```

A vector that is two elements long.

## ON_FREE


```lua
EventLib
```

## Offset


```lua
Vector2
```

A vector that is two elements long.

## PADDING_CHANGED


```lua
EventLib
```

## PARENT_CHANGED


```lua
table
```

## PRESSED


```lua
EventLib
```

## Padding


```lua
Vector4
```

A vector that is four elements long.

## Parent


```lua
GNUI.container|GNUI.element
```

## Part


```lua
ModelPart
```

A part of the avatar's model.  
This can be a group, cube, or mesh.

## RenderTasks


```lua
table<any, TextTask>
```

## SIZE_CHANGED


```lua
EventLib
```

## SPRITE_CHANGED


```lua
EventLib
```

## Sprite


```lua
Sprite
```

## TEXT_CHANGED


```lua
EventLib
```

## Text


```lua
string
```

## TextData


```lua
table
```

## TextEffect


```lua
TextEffect
```

## VISIBILITY_CHANGED


```lua
EventLib
```

## Visible


```lua
boolean
```

## WrapText


```lua
boolean
```

## Z


```lua
number
```

## _TextChanged


```lua
boolean
```

for optimization purposes

## __index


```lua
function GNUI.Label.__index(t: any, i: any)
  -> unknown
```

## __type


```lua
string
```

## _bakeWords


```lua
(method) GNUI.Label:_bakeWords()
  -> GNUI.Label
```

## _buildRenderTasks


```lua
(method) GNUI.Label:_buildRenderTasks()
  -> GNUI.Label
```

## _deleteRenderTasks


```lua
(method) GNUI.Label:_deleteRenderTasks()
  -> GNUI.Label
```

## _updateRenderTasks


```lua
(method) GNUI.Label:_updateRenderTasks()
  -> GNUI.Label|nil
```

## addChild


```lua
(method) GNUI.element:addChild(child: GNUI.element, index?: integer)
  -> GNUI.element
```

Adopts an element as its child.

## canCaptureCursor


```lua
(method) GNUI.container:canCaptureCursor(capture: boolean)
  -> GNUI.container
```

If this container should be able to capture the cursor from its parent if obstructed.

## free


```lua
(method) GNUI.element:free()
```

Frees all the data of the element. all thats left to do is to forget it ever existed.

## id


```lua
EventLib
```

## isClipping


```lua
boolean
```

## isHovering


```lua
(method) GNUI.container:isHovering(x: number|Vector2, y?: number)
  -> boolean
```

Checks if the cursor in local coordinates is inside the bounding box of this container.

## isVisible


```lua
boolean
```

## new


```lua
function GNUI.Label.new(preset: any)
  -> GNUI.Label
```

## offsetBottomRight


```lua
(method) GNUI.container:offsetBottomRight(zpos: number|Vector2, w?: number)
  -> GNUI.container
```

Shifts the container based on the bottom right.

## offsetTopLeft


```lua
(method) GNUI.container:offsetTopLeft(xpos: number|Vector2, y?: number)
  -> GNUI.container
```

Shifts the container based on the top left.

## removeChild


```lua
(method) GNUI.element:removeChild(child: GNUI.element)
  -> GNUI.element
```

Abandons the child into the street.

## setAlign


```lua
(method) GNUI.Label:setAlign(horizontal?: number, vertical?: number)
  -> GNUI.Label
```

Sets how the text is anchored to the container.  
left 0 <-> 1 right  
up 0 <-> 1 down  
 horizontal or vertical by default is 0

## setAnchor


```lua
(method) GNUI.container:setAnchor(left: number, top: number, right?: number, bottom?: number)
  -> GNUI.container
```

Sets the anchor for all sides.  
 x 0 <-> 1 = left <-> right  
 y 0 <-> 1 = top <-> bottom  
if right and bottom are not given, they will use left and top instead.

## setAnchorDown


```lua
(method) GNUI.container:setAnchorDown(units?: number)
  -> GNUI.container
```

Sets the down anchor.  
 0 = bottom part of the container is fully anchored to the top of its parent  
 1 = bottom part of the container is fully anchored to the bottom of its parent

## setAnchorLeft


```lua
(method) GNUI.container:setAnchorLeft(units?: number)
  -> GNUI.container
```

Sets the left anchor.  
 0 = left part of the container is fully anchored to the left of its parent  
 1 = left part of the container is fully anchored to the right of its parent

## setAnchorRight


```lua
(method) GNUI.container:setAnchorRight(units?: number)
  -> GNUI.container
```

Sets the right anchor.  
 0 = right part of the container is fully anchored to the left of its parent  
 1 = right part of the container is fully anchored to the right of its parent  

## setAnchorTop


```lua
(method) GNUI.container:setAnchorTop(units?: number)
  -> GNUI.container
```

Sets the top anchor.  
 0 = top part of the container is fully anchored to the top of its parent  
 1 = top part of the container is fully anchored to the bottom of its parent

## setBottomRight


```lua
(method) GNUI.container:setBottomRight(xsize: number|Vector2, y?: number)
  -> GNUI.container
```

Sets the bottom right offset from the origin anchor of its parent.

## setClipOnParent


```lua
(method) GNUI.container:setClipOnParent(clip: any)
  -> GNUI.container
```

Sets the flag if this container should go invisible once touching outside of its parent.

## setCursor


```lua
(method) GNUI.container:setCursor(x?: number, y?: number, press?: boolean)
  -> boolean
```

Sets the Cursor position relative to the top left of the container.  
Returns true if the cursor is hovering over the container.  

## setDimensions


```lua
(method) GNUI.container:setDimensions(x: number, y?: number, w?: number, t?: number)
  -> GNUI.container
```

Sets the dimensions of this container.  
x,y is top left
z,w is bottom right  
 if Z or W is missing, they will use X and Y instead

## setFontScale


```lua
(method) GNUI.Label:setFontScale(scale: number)
  -> GNUI.Label
```

Sets the font scale for all text thats by this container.

## setSprite


```lua
(method) GNUI.container:setSprite(sprite_obj: Sprite)
  -> GNUI.container
```

Sets the backdrop of the container.  
note: the object dosent get applied directly, its duplicated and the clone is used instead of the original.

## setText


```lua
(method) GNUI.Label:setText(text: string|table)
  -> GNUI.Label
```

## setTextEffect


```lua
(method) GNUI.Label:setTextEffect(effect: TextEffect)
  -> GNUI.Label
```

```lua
effect:
    | "NONE"
    | "OUTLINE"
    | "SHADOW"
```

## setTopLeft


```lua
(method) GNUI.container:setTopLeft(xpos: number|Vector2, y?: number)
  -> GNUI.container
```

Sets the top left offset from the origin anchor of its parent.

## setVisible


```lua
(method) GNUI.container:setVisible(visible: boolean)
  -> GNUI.container
```

Sets the visibility of the container and its children

## setZ


```lua
(method) GNUI.container:setZ(depth: number)
  -> GNUI.container
```

Sets the offset of the depth for this container, a work around to fixing Z fighting issues when two elements overlap.

## updateChildrenIndex


```lua
(method) GNUI.element:updateChildrenIndex()
```

## updateChildrenOrder


```lua
(method) GNUI.element:updateChildrenOrder()
  -> GNUI.element
```

## wrapText


```lua
(method) GNUI.Label:wrapText(wrap: any)
```


---

# GNUI.container

## ANCHOR_CHANGED


```lua
EventLib
```

## Anchor


```lua
Vector4
```

A vector that is four elements long.

## CHILDREN_CHANGED


```lua
table
```

## CURSOR_CHANGED


```lua
EventLib
```

## CaptureCursor


```lua
boolean
```

## ChildIndex


```lua
integer
```

## Children


```lua
table<any, GNUI.container|GNUI.element>
```

## ClipOnParent


```lua
boolean
```

## ContainerShift


```lua
Vector2
```

A vector that is two elements long.

## ContainmentRect


```lua
Vector4
```

A vector that is four elements long.

## Cursor


```lua
Vector2?
```

A vector that is two elements long.

## DIMENSIONS_CHANGED


```lua
EventLib
```

## Dimensions


```lua
Vector4
```

A vector that is four elements long.

## GrowDirection


```lua
Vector2
```

A vector that is two elements long.

## Hovering


```lua
boolean
```

## MARGIN_CHANGED


```lua
EventLib
```

## MOUSE_ENTERED


```lua
EventLib
```

## MOUSE_EXITED


```lua
EventLib
```

## Margin


```lua
Vector4
```

A vector that is four elements long.

## MinimumSize


```lua
Vector2
```

A vector that is two elements long.

## ON_FREE


```lua
EventLib
```

## PADDING_CHANGED


```lua
EventLib
```

## PARENT_CHANGED


```lua
table
```

## PRESSED


```lua
EventLib
```

## Padding


```lua
Vector4
```

A vector that is four elements long.

## Parent


```lua
GNUI.container|GNUI.element
```

## Part


```lua
ModelPart
```

A part of the avatar's model.  
This can be a group, cube, or mesh.

## SIZE_CHANGED


```lua
EventLib
```

## SPRITE_CHANGED


```lua
EventLib
```

## Sprite


```lua
Sprite
```

## VISIBILITY_CHANGED


```lua
EventLib
```

## Visible


```lua
boolean
```

## Z


```lua
number
```

## __index


```lua
function GNUI.container.__index(t: any, i: any)
  -> unknown
```

## __type


```lua
string
```

## addChild


```lua
(method) GNUI.element:addChild(child: GNUI.element, index?: integer)
  -> GNUI.element
```

Adopts an element as its child.

## canCaptureCursor


```lua
(method) GNUI.container:canCaptureCursor(capture: boolean)
  -> GNUI.container
```

If this container should be able to capture the cursor from its parent if obstructed.

## free


```lua
(method) GNUI.element:free()
```

Frees all the data of the element. all thats left to do is to forget it ever existed.

## id


```lua
EventLib
```

## isClipping


```lua
boolean
```

## isHovering


```lua
(method) GNUI.container:isHovering(x: number|Vector2, y?: number)
  -> boolean
```

Checks if the cursor in local coordinates is inside the bounding box of this container.

## isVisible


```lua
boolean
```

## new


```lua
function GNUI.container.new(preset?: GNUI.container, force_debug?: boolean)
  -> GNUI.container
```

Creates a new container.

## offsetBottomRight


```lua
(method) GNUI.container:offsetBottomRight(zpos: number|Vector2, w?: number)
  -> GNUI.container
```

Shifts the container based on the bottom right.

## offsetTopLeft


```lua
(method) GNUI.container:offsetTopLeft(xpos: number|Vector2, y?: number)
  -> GNUI.container
```

Shifts the container based on the top left.

## removeChild


```lua
(method) GNUI.element:removeChild(child: GNUI.element)
  -> GNUI.element
```

Abandons the child into the street.

## setAnchor


```lua
(method) GNUI.container:setAnchor(left: number, top: number, right?: number, bottom?: number)
  -> GNUI.container
```

Sets the anchor for all sides.  
 x 0 <-> 1 = left <-> right  
 y 0 <-> 1 = top <-> bottom  
if right and bottom are not given, they will use left and top instead.

## setAnchorDown


```lua
(method) GNUI.container:setAnchorDown(units?: number)
  -> GNUI.container
```

Sets the down anchor.  
 0 = bottom part of the container is fully anchored to the top of its parent  
 1 = bottom part of the container is fully anchored to the bottom of its parent

## setAnchorLeft


```lua
(method) GNUI.container:setAnchorLeft(units?: number)
  -> GNUI.container
```

Sets the left anchor.  
 0 = left part of the container is fully anchored to the left of its parent  
 1 = left part of the container is fully anchored to the right of its parent

## setAnchorRight


```lua
(method) GNUI.container:setAnchorRight(units?: number)
  -> GNUI.container
```

Sets the right anchor.  
 0 = right part of the container is fully anchored to the left of its parent  
 1 = right part of the container is fully anchored to the right of its parent  

## setAnchorTop


```lua
(method) GNUI.container:setAnchorTop(units?: number)
  -> GNUI.container
```

Sets the top anchor.  
 0 = top part of the container is fully anchored to the top of its parent  
 1 = top part of the container is fully anchored to the bottom of its parent

## setBottomRight


```lua
(method) GNUI.container:setBottomRight(xsize: number|Vector2, y?: number)
  -> GNUI.container
```

Sets the bottom right offset from the origin anchor of its parent.

## setClipOnParent


```lua
(method) GNUI.container:setClipOnParent(clip: any)
  -> GNUI.container
```

Sets the flag if this container should go invisible once touching outside of its parent.

## setCursor


```lua
(method) GNUI.container:setCursor(x?: number, y?: number, press?: boolean)
  -> boolean
```

Sets the Cursor position relative to the top left of the container.  
Returns true if the cursor is hovering over the container.  

## setDimensions


```lua
(method) GNUI.container:setDimensions(x: number, y?: number, w?: number, t?: number)
  -> GNUI.container
```

Sets the dimensions of this container.  
x,y is top left
z,w is bottom right  
 if Z or W is missing, they will use X and Y instead

## setSprite


```lua
(method) GNUI.container:setSprite(sprite_obj: Sprite)
  -> GNUI.container
```

Sets the backdrop of the container.  
note: the object dosent get applied directly, its duplicated and the clone is used instead of the original.

## setTopLeft


```lua
(method) GNUI.container:setTopLeft(xpos: number|Vector2, y?: number)
  -> GNUI.container
```

Sets the top left offset from the origin anchor of its parent.

## setVisible


```lua
(method) GNUI.container:setVisible(visible: boolean)
  -> GNUI.container
```

Sets the visibility of the container and its children

## setZ


```lua
(method) GNUI.container:setZ(depth: number)
  -> GNUI.container
```

Sets the offset of the depth for this container, a work around to fixing Z fighting issues when two elements overlap.

## updateChildrenIndex


```lua
(method) GNUI.element:updateChildrenIndex()
```

## updateChildrenOrder


```lua
(method) GNUI.element:updateChildrenOrder()
  -> GNUI.element
```


---

# GNUI.element

## CHILDREN_CHANGED


```lua
table
```

## ChildIndex


```lua
integer
```

## Children


```lua
table<any, GNUI.container|GNUI.element>
```

## ON_FREE


```lua
EventLib
```

## PARENT_CHANGED


```lua
table
```

## Parent


```lua
GNUI.container|GNUI.element
```

## VISIBILITY_CHANGED


```lua
EventLib
```

## Visible


```lua
boolean
```

## __index


```lua
function GNUI.element.__index(t: any, i: any)
  -> unknown
```

## __type


```lua
string
```

## addChild


```lua
(method) GNUI.element:addChild(child: GNUI.element, index?: integer)
  -> GNUI.element
```

Adopts an element as its child.

## free


```lua
(method) GNUI.element:free()
```

Frees all the data of the element. all thats left to do is to forget it ever existed.

## id


```lua
EventLib
```

## new


```lua
function GNUI.element.new(preset?: table)
  -> GNUI.element
```

Creates a new basic element.

## removeChild


```lua
(method) GNUI.element:removeChild(child: GNUI.element)
  -> GNUI.element
```

Abandons the child into the street.

## updateChildrenIndex


```lua
(method) GNUI.element:updateChildrenIndex()
```

## updateChildrenOrder


```lua
(method) GNUI.element:updateChildrenOrder()
  -> GNUI.element
```


---

# GNtween

## duration


```lua
number
```

## from


```lua
number
```

## id


```lua
string|number
```

## on_finish


```lua
function?
```

## start


```lua
number
```

## tick


```lua
fun(value: number, transition: number)
```

## to


```lua
number
```

## type


```lua
EaseTypes
```


---

# InputEventKey

## __index


```lua
InputEventKey
```

## __type


```lua
string
```

## alt


```lua
boolean
```

## char


```lua
string
```

## ctrl


```lua
boolean
```

## echo


```lua
boolean
```

## key


```lua
integer
```

## modifier


```lua
integer
```

## pressed


```lua
boolean
```

## shift


```lua
boolean
```


---

# InputEventMouseButton

## __index


```lua
InputEventMouseButton
```

## __type


```lua
string
```

## button_index


```lua
Minecraft.mouseid
```

A valid mouse button id for use in the `MOUSE_PRESS` event.

## modifiers


```lua
Event.Press.modifiers
```

## state


```lua
Event.Press.state
```


---

# InputEventMouseMotion

## __index


```lua
InputEventMouseMotion
```

## __type


```lua
string
```

## absolute


```lua
Vector2
```

A vector that is two elements long.

## relative


```lua
Vector2
```

A vector that is two elements long.


---

# InputListener

## InputEvent


```lua
EventLib
```

## __index


```lua
InputListener
```

## __type


```lua
string
```

## active


```lua
boolean
```

## delete


```lua
(method) InputListener:delete()
```

## id


```lua
integer
```

## new


```lua
function InputListener.new()
  -> table
```


---

# Skull.StorageLabel

## item


```lua
(Minecraft.itemID)?
```

## items


```lua
table<any, Minecraft.itemID>?
```

## name


```lua
string
```

## pos


```lua
Vector2
```

A vector that is two elements long.

## renderTask


```lua
{ title: TextTask, icon: ItemTask }?
```


---

# SkullEvents

## EXIT


```lua
EventLib
```

## FRAME


```lua
EventLib
```

## INIT


```lua
EventLib
```

## TICK


```lua
EventLib
```


---

# Sprite

## BORDER_THICKNESS_CHANGED


```lua
EventLib
```

## BorderThickness


```lua
Vector4
```

A vector that is four elements long.

## Color


```lua
Vector3
```

A vector that is three elements long.

## DIMENSIONS_CHANGED


```lua
EventLib
```

## ExcludeMiddle


```lua
boolean
```

## MODELPART_CHANGED


```lua
EventLib
```

## Modelpart


```lua
ModelPart?
```

A part of the avatar's model.  
This can be a group, cube, or mesh.

## Position


```lua
Vector3
```

A vector that is three elements long.

## RenderTasks


```lua
table<any, SpriteTask>
```

## RenderType


```lua
ModelPart.renderType
```

## Scale


```lua
number
```

## Size


```lua
Vector2
```

A vector that is two elements long.

## TEXTURE_CHANGED


```lua
EventLib
```

## Texture


```lua
Texture
```

A texture for use by the avatar.

## UV


```lua
Vector4
```

A vector that is four elements long.

## Visible


```lua
boolean
```

## __index


```lua
Sprite
```

## _buildRenderTasks


```lua
(method) Sprite:_buildRenderTasks()
  -> Sprite
```

## _deleteRenderTasks


```lua
(method) Sprite:_deleteRenderTasks()
  -> Sprite
```

## _updateRenderTasks


```lua
(method) Sprite:_updateRenderTasks()
  -> Sprite
```

## copy


```lua
(method) Sprite:copy()
  -> Sprite
```

## excludeMiddle


```lua
(method) Sprite:excludeMiddle(toggle: boolean)
  -> Sprite
```

Set to true if you want a hole in the middle of your ninepatch

## id


```lua
integer
```

## is_ninepatch


```lua
boolean
```

## new


```lua
function Sprite.new(obj: any)
  -> Sprite
```

## setBorderThickness


```lua
(method) Sprite:setBorderThickness(left?: number, top?: number, right?: number, bottom?: number)
  -> Sprite
```

Sets the padding for all sides.

## setBorderThicknessDown


```lua
(method) Sprite:setBorderThicknessDown(units?: number)
  -> Sprite
```

Sets the down border thickness.

## setBorderThicknessLeft


```lua
(method) Sprite:setBorderThicknessLeft(units?: number)
  -> Sprite
```

Sets the left border thickness.

## setBorderThicknessRight


```lua
(method) Sprite:setBorderThicknessRight(units?: number)
  -> Sprite
```

Sets the right border thickness.

## setBorderThicknessTop


```lua
(method) Sprite:setBorderThicknessTop(units?: number)
  -> Sprite
```

Sets the top border thickness.

## setColor


```lua
(method) Sprite:setColor(r: number, g: number, b: number)
  -> Sprite
```

Tints the Sprite multiplicatively

## setModelpart


```lua
(method) Sprite:setModelpart(part: ModelPart)
  -> Sprite
```

Sets the modelpart to parent to.

## setPos


```lua
(method) Sprite:setPos(xpos: number, y: number, depth?: number)
  -> Sprite
```

Sets the position of the Sprite, relative to its parent.

## setRenderType


```lua
(method) Sprite:setRenderType(renderType: ModelPart.renderType)
  -> Sprite
```

Sets the render type of your sprite

```lua
renderType:
    | "NONE" -- Disable rendering.
    | "CUTOUT" -- Default render mode. Used for simple opaque and transparent parts.
    | "CUTOUT_CULL" -- Similar to `"CUTOUT"`, but inside faces do not render.
    | "TRANSLUCENT" -- Used to allow translucency.
    | "TRANSLUCENT_CULL" -- Similar to `"TRANSLUCENT"`, but inside faces do not render.
    | "EMISSIVE" -- Default secondary render mode. Used for emissive textures.
    | "EMISSIVE_SOLID" -- Similar to `"EMISSIVE"`, but color is not additive.
    | "END_PORTAL" -- Applies the end portal field effect.
    | "END_GATEWAY" -- Similar to `"END_PORTAL"`, but contains another layer of blue "particles".
    | "GLINT" -- Applies the enchantment glint effect.
    | "GLINT2" -- Similar to `"GLINT"`, but with only one denser glint layer.
    | "LINES" -- Adds a white outline.
    | "LINES_STRIP" -- Similar to `"LINES"`, but also adds some more lines in-between.
```

## setScale


```lua
(method) Sprite:setScale(scale: number)
  -> Sprite
```

## setSize


```lua
(method) Sprite:setSize(xpos: number, y: number)
  -> Sprite
```

Sets the size of the sprite duh.

## setTexture


```lua
(method) Sprite:setTexture(texture: Texture)
  -> Sprite
```

Sets the displayed image texture on the sprite.

## setUV


```lua
(method) Sprite:setUV(x: number, y: number, x2: number, y2: number)
  -> Sprite
```

Sets the UV region of the sprite.
 if x2 and y2 are missing, they will use x and y as a substitute

## setVisible


```lua
(method) Sprite:setVisible(visibility: any)
  -> Sprite
```


---

# TextEffect

```lua
TextEffect:
    | "NONE"
    | "OUTLINE"
    | "SHADOW"
```


```lua
string|"NONE"|"OUTLINE"|"SHADOW"
```


---

# WorldSkull

## dir


```lua
Vector3
```

A vector that is three elements long.

## id


```lua
string
```

## is_wall


```lua
boolean
```

## last_seen


```lua
number
```

## model


```lua
ModelPart
```

A part of the avatar's model.  
This can be a group, cube, or mesh.

## model_block


```lua
ModelPart
```

A part of the avatar's model.  
This can be a group, cube, or mesh.

## offset_model


```lua
Vector3
```

A vector that is three elements long.

## order


```lua
integer
```

## pos


```lua
Vector3
```

A vector that is three elements long.

## rot


```lua
number
```


---

# _G

A global variable (not a function) that holds the global environment (see
[§2.2](command:extension.lua.doc?["en-us/52/manual.html/2.2"])). Lua itself does not use this
variable; changing its value does not affect any environment, nor vice versa.

[View documents](command:extension.lua.doc?["en-us/52/manual.html/pdf-_G"])


```lua
_G
```


---

# _GS

A global variable (not a function) that holds the global environment (see
[§2.2](command:extension.lua.doc?["en-us/52/manual.html/2.2"])). Lua itself does not use this
variable; changing its value does not affect any environment, nor vice versa.

[View documents](command:extension.lua.doc?["en-us/52/manual.html/pdf-_G"])


```lua
_G
```


---

# _VERSION

A global variable (not a function) that holds a string containing the running Lua version.

~~[View documents](command:extension.lua.doc?["en-us/52/manual.html/pdf-_VERSION"])~~  
This variable has been modified by Figura and does not have the same value as in normal Lua 5.2.


```lua
string
```


---

# action_wheel

An API for customizing the action wheel.

> ***

The action wheel works off a page system. The action wheel can be assigned a page of up to 8 actions to show.

Create a new page with:
```lua
local page_var = <ActionWheelAPI>:newPage()
```
&emsp;  
There are two ways to create a new action.  
Either create the action and set its values later:
```lua
local action = page_var:newAction()

action:title("Cool title")
action:item("minecraft:stick")
action:onLeftClick(function()
  print("hello world")
end)
```
Or create the action and its values at the same time:
```lua
page_var:newAction()
  :title("Cool title")
  :item("minecraft:stick")
  :onLeftClick(function()
    print("hello world")
  end)
```
&emsp;  
Once the page is done being created, apply it to the action wheel with:
```lua
<ActionWheelAPI>:setPage(page_var)
```


```lua
ActionWheelAPI
```


---

# allowedOutputTypes

```lua
"string" | "base64" | "byteArray"
```


---

# animation

`animation` is deprecated. To get all animations in the avatar, use `animations`.

Animations are now accessed per-model by indexing `animations` with the name of the bbmodel file.  
(To get animations from `mycoolmodel.bbmodel`, do `animations.mycoolmodel`.)


```lua
nil
```


---

# animationStateMachine

## __index


```lua
animationStateMachine
```

## blend_time


```lua
number
```

## current_animation


```lua
Animation?
```

A Blockbench animation.

## id


```lua
integer
```

## last_animation


```lua
Animation?
```

A Blockbench animation.

## new


```lua
function animationStateMachine.new()
  -> animationStateMachine
```

## queue_next


```lua
table<any, Animation>
```

## setAnimation


```lua
(method) animationStateMachine:setAnimation(animation?: Animation, force?: boolean)
  -> animationStateMachine
```

Transitions to the given animation from the last playing one.  
default value is none, this will just blend to having no animation at all

## setBlendTime


```lua
(method) animationStateMachine:setBlendTime(seconds: any)
  -> animationStateMachine
```


---

# animations

An API for handling the animations of this avatar.

Indexing this API with a string that does not result in a method may return a table of
`Animation` objects.

> ***

To access the animations of an avatar, use:
```lua
animations.<bbmodel_name>.<animation_name>
```
&emsp;  
Be careful when naming animations, an animation name that contains special characters (such as `.`) or matches a Lua
keyword is not a valid identifier and requires an alternate way of accessing the animation.

If an animation is named `and`, it will conflict with the Lua keyword `and`.
```lua
animations.MyModel.and    -- Causes an error, Lua did not expect a keyword here.
animations.MyModel["and"] -- Does not error, the keyword is contained in a string.
```
If an animation name contains special symbols, it will fail due to Lua trying to read the symbol.
```lua
animations.MyModel.some-animation    -- Causes an error, Lua did not expect a minus here.
animations.MyModel["some-animation"] -- Does not error, the minus is contained in a string.
```
If an animation name starts with a number, it will fail due to Lua trying to read the number.
```lua
animations.MyModel.42bottles    -- Causes an error, Lua did not expect a number here.
animations.MyModel["42bottles"] -- Does not error, the number is contained in a string.
```
If an animation contains periods in its name, it will fail due to how Lua treats them.
```lua
animations.MyModel.anim.with.dots    -- Causes an error, attempts to read `.with` in `.anim`.
animations.MyModel["anim.with.dots"] -- Does not error, the periods are contained in a string.

animations.MyModel.anim_with_no_dots -- Remove the periods instead. This is preferred!
```


```lua
AnimationAPI
```


---

# armor_model

`armor_model` is deprecated. Replace the following:
* `armor_model.HELMET` with `vanilla_model.HELMET`
* `armor_model.HEAD_ITEM` with `vanilla_model.HELMET_ITEM`
* `armor_model.CHESTPLATE` with `vanilla_model.CHESTPLATE`
* `armor_model.LEGGINGS` with `vanilla_model.LEGGINGS`
* `armor_model.BOOTS` with `vanilla_model.BOOTS`

&nbsp;
### If `ARMOR_MODEL` IS PART OF A `FOR IN` LOOP...
```lua
for _, v in pairs(armor_model) do
  v.setEnabled(<state>)
end
```
The ***entire loop*** should be replaced with
```lua
vanilla_model.ARMOR:setVisible(<state>)
```


```lua
nil
```


---

# assert

Raises an error if the value of its argument v is false (i.e., `nil` or `false`); otherwise,
returns all its arguments. In case of error, `message` is the error object; when absent,
it defaults to `"assertion failed!"`

[View documents](command:extension.lua.doc?["en-us/52/manual.html/pdf-assert"])


```lua
function assert(v?: <T>, message?: any)
  -> <T>
```


---

# avatar

An API mainly used for getting avatar metadata.

> ***

This API contains many getters for avatar metadata and avatar resources.

Avatar metadata includes the data in the `avatar.json` file, the total size of the avatar, and the existence of
certain types of files.

Avatar resources include current/max script instructions and current/max model & animation complexity.

This API also controls avatar variables through `<AvatarAPI>:store()`.


```lua
AvatarAPI
```


---

# biome

`biome` is deprecated. Replace the following:
* `biome.getBiome()` with `world.getBiome()`


```lua
nil
```


---

# bit32




[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-bit32"])



```lua
bit32lib
```


---

# bit32.arshift


Returns the number `x` shifted `disp` bits to the right. Negative displacements shift to the left.

This shift operation is what is called arithmetic shift. Vacant bits on the left are filled with copies of the higher bit of `x`; vacant bits on the right are filled with zeros.


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-bit32.arshift"])


```lua
function bit32.arshift(x: integer, disp: integer)
  -> integer
```


---

# bit32.band


Returns the bitwise *and* of its operands.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-bit32.band"])


```lua
function bit32.band(...any)
  -> integer
```


---

# bit32.bnot


Returns the bitwise negation of `x`.

```lua
assert(bit32.bnot(x) ==
(-1 - x) % 2^32)
```


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-bit32.bnot"])


```lua
function bit32.bnot(x: integer)
  -> integer
```


---

# bit32.bor


Returns the bitwise *or* of its operands.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-bit32.bor"])


```lua
function bit32.bor(...any)
  -> integer
```


---

# bit32.btest


Returns a boolean signaling whether the bitwise *and* of its operands is different from zero.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-bit32.btest"])


```lua
function bit32.btest(...any)
  -> boolean
```


---

# bit32.bxor


Returns the bitwise *exclusive or* of its operands.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-bit32.bxor"])


```lua
function bit32.bxor(...any)
  -> integer
```


---

# bit32.extract


Returns the unsigned number formed by the bits `field` to `field + width - 1` from `n`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-bit32.extract"])


```lua
function bit32.extract(n: integer, field: integer, width?: integer)
  -> integer
```


---

# bit32.lrotate


Returns the number `x` rotated `disp` bits to the left. Negative displacements rotate to the right.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-bit32.lrotate"])


```lua
function bit32.lrotate(x: integer, distp: integer)
  -> integer
```


---

# bit32.lshift


Returns the number `x` shifted `disp` bits to the left. Negative displacements shift to the right. In any direction, vacant bits are filled with zeros.

```lua
assert(bit32.lshift(b, disp) ==
(b * 2^disp) % 2^32)
```


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-bit32.lshift"])


```lua
function bit32.lshift(x: integer, distp: integer)
  -> integer
```


---

# bit32.replace


Returns a copy of `n` with the bits `field` to `field + width - 1` replaced by the value `v` .

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-bit32.replace"])


```lua
function bit32.replace(n: integer, v: integer, field: integer, width?: integer)
```


---

# bit32.rrotate


Returns the number `x` rotated `disp` bits to the right. Negative displacements rotate to the left.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-bit32.rrotate"])


```lua
function bit32.rrotate(x: integer, distp: integer)
  -> integer
```


---

# bit32.rshift


Returns the number `x` shifted `disp` bits to the right. Negative displacements shift to the left. In any direction, vacant bits are filled with zeros.

```lua
assert(bit32.rshift(b, disp) ==
math.floor(b % 2^32 / 2^disp))
```


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-bit32.rshift"])


```lua
function bit32.rshift(x: integer, distp: integer)
  -> integer
```


---

# block_state

`block_state` is deprecated. Replace the following:
* `block_state.createBlock()` with `world.newBlock()`.


```lua
nil
```


---

# camera

`camera` is deprecated. Replace the following: 
* <code>camera.‹<small><sup>FIRST_PERSON</sup></small>⁄<small><small>THIRD_PERSON</small></small>›.getPivot()</code>
  with `renderer:getCameraOffsetPivot()`
* <code>camera.‹<small><sup>FIRST_PERSON</sup></small>⁄<small><small>THIRD_PERSON</small></small>›.getRot()</code>
  with `renderer:getCameraOffsetRot()`
* <code>camera.‹<small><sup>FIRST_PERSON</sup></small>⁄<small><small>THIRD_PERSON</small></small>›.getPos()</code>
  with `renderer:getCameraPos()`
* <code>camera.‹<small><sup>FIRST_PERSON</sup></small>⁄<small><small>THIRD_PERSON</small></small>›.setPivot()</code>
  with `renderer:offsetCameraPivot()`
* <code>camera.‹<small><sup>FIRST_PERSON</sup></small>⁄<small><small>THIRD_PERSON</small></small>›.setRot()</code>
  with `renderer:offsetCameraRot()`
* <code>camera.‹<small><sup>FIRST_PERSON</sup></small>⁄<small><small>THIRD_PERSON</small></small>›.setPos()</code>
  with `renderer:setCameraPos()`


```lua
nil
```


---

# chat

`chat` is deprecated. Replace the following:
* `chat.getMessage()` with `host:getChatMessage()`
* `chat.isOpen()` with `host:isChatOpen()`
* `chat.sendMessage()` with `host:sendChatMessage()`/`host:sendCommandMessage()`
* `chat.getInputText()` with `host:getChatText()`

`chat.setFiguraCommandPrefix()` does not have a direct counterpart, however its functionality can be emulated with
the `CHAT_SEND_MESSAGE` event.


```lua
nil
```


---

# client

An API for getting information from the Minecraft game client.


```lua
ClientAPI
```


---

# config

An API for storing and loading information between avatar sessions.


```lua
ConfigAPI
```


---

# data

`data` is deprecated. Replace the following:
* `data.getName()` with `config:getName()`
* `data.setName()` with `config:setName()`
* `data.load()` and `data.loadAll()` with `config:load()`
* `data.save()` and `data.remove()` with `config:save()`

The following do not have a replacement:
* `data.allowTracking()`
* `data.deleteFile()`
* `data.hasTracking()`


```lua
nil
```


---

# elytra_model

`elytra_model` is deprecated. Replace the following:
* `elytra_model.LEFT_WING` with `vanilla_model.LEFT_ELYTRA`
* `elytra_model.RIGHT_WING` with `vanilla_model.RIGHT_ELYTRA`

&nbsp;
### IF `ELYTRA_MODEL` IS PART OF A `FOR IN` LOOP...
```lua
for _, v in pairs(elytra_model) do
  v.setEnabled(<state>)
end
```
The ***entire loop*** should be replaced with
```lua
vanilla_model.ELYTRA:setVisible(<state>)
```


```lua
nil
```


---

# error

Terminates the last protected function called and returns message as the error object.

Usually, `error` adds some information about the error position at the beginning of the message,
if the message is a string.

[View documents](command:extension.lua.doc?["en-us/52/manual.html/pdf-error"])


```lua
function error(message: any, level?: integer)
```


---

# events

An API that contains all of the in-game events that Figura handles.

Events can have callback functions registered to them which will run when the event does.


```lua
EventsAPI
```


---

# events.CHAT_RECEIVE_MESSAGE


```lua
function events.CHAT_RECEIVE_MESSAGE(message: string, json: string)
  -> boolean|string|nil
  2. Vector3|nil
```


---

# events.CHAT_SEND_MESSAGE


```lua
function events.CHAT_SEND_MESSAGE(message: string)
  -> string|nil
```


---

# events.ENTITY_INIT


```lua
function events.ENTITY_INIT()
```


---

# events.TICK


```lua
function events.TICK()
```


---

# events.tick


```lua
function events.tick()
```


```lua
function events.tick()
```


---

# figuraMetatables

A table containing all metatables used by Figura.

Metatables are tables that control how Lua handles other tables.  
They define behaviors such as how mathematical operators should handle the object or what to do
if the object is treated like a function.

Metamethods are the functions that control the behaviors that Lua follows.  
A list of metamethods is given below:
***
> ```lua
> (field) __index: table
> function __index(self: table, key: any)
>   -> value: any
> ```
> ***
> This metamethod runs when the given `key` is requested from a table but does not exist in the
> table.  
> *This metamethod can be skipped with `rawget(table, key)`.*
>
> If `__index` is a table, that table is searched for the key instead. This allows tables to
> have *prototype inheritance*.  
> If it is a function, the function is given the table that was being searched and the key that
> was used and is expected to return a value that would be at that key.
>
> If `__index` is a table and that table also doesn't have the given `key` *and* has a metatable
> with an `__index` metamethod, the process repeats.
>
> An example of a valid `__index` metamethod that causes a table to return the negative of any
> number key put into it.
> ```lua
> local Object = {}
> setmetatable(Object, {
>   __index(self, key)
>     if type(key) == "number" then return -key end
>   end
> })
>
> print(Object[2])    --> -2
> print(Object[1.24]) --> -1.24
> print(Object[-6])   --> 6
> ```
> An example of prototype inheritance with metatables.
> > ```lua
> > local FirstClass = {SayHi = function() print("Hi!") end}
> >
> > local SecondClass = {SayBye = function() print("Bye!") end}
> > setmetatable(SecondClass, {__index = FirstClass})
> >
> > local ThirdClass = {SayFoo = function() print("foo") end}
> > setmetatable(ThirdClass, {__index = SecondClass})
> >
> > ThirdClass.SayHi()  --> Hi!
> > ThirdClass.SayBye() --> Bye!
> > ThirdClass.SayFoo() --> foo
> ```
***
&nbsp;  
&nbsp;
***
> ```lua
> function __newindex(self: table, key: any, value: any)
> ```
> ***
> This metamethod runs when the given `key` is being set in a table but does not already exist in
> the table.  
> *This metamethod can be skipped with `rawset(table, key, value)`.*
>
> If this metamethod exists, it will override the default behavior of creating the `key` in the
> table with the given `value`. To return this behavior, a `rawset()` must exist in the metamethod
> that adds the key to the table. (An example of this is given further down.)
>
> An example of a valid `__newindex` metamethod that causes all string keys to be prefixed with a
> `_`.
> > ```lua
> > local Object = {}
> > setmetatable(Object, {
> >   __newindex = function(self, key, value)
> >     if type(key) == "string" then
> >       rawset(self, "_" .. key, value)
> >     else
> >       rawset(self, key, value)
> >     end
> >   end
> > })
> >
> > Object.foo = 5
> > print(Object.foo)  --> nil
> > print(Object._foo) --> 5
> > ```
***
&nbsp;  
&nbsp;
***
> ```lua
> function __call(self: <self>, ...any)
>   -> ...any
> ```
> ***
> This metamethod runs when a table is being called like a function.
>
> Where calling a table like a function would normally error, this metamethod stops that error and
> instead calls itself in place of the table. The first argument passed into the metamethod is the
> table that was called and the rest of the arguments are taken from the original call.
>
> An example of a valid `__call` metamethod that causes a counter object to count up and return
> its new value.
> > ```lua
> > local Counter = {value = 0}
> > setmetatable(Counter, {
> >   __call = function(self, n)
> >     self.value = self.value + (n or 1)
> >     return self.value
> >   end
> > })
> >
> > print(Counter())  --> 1
> > print(Counter(5)) --> 6
> > print(Counter())  --> 7
> > ```
***
&nbsp;  
&nbsp;
***
> ```lua
> (field) __mode: "k" | "v" | "kv"
> ```
> ***
> This metamethod controls which parts of a table are considered "weak references".
>
> If `"k"` exists in the `__mode` string, keys are considered weak.  
> If `"v"` exists in the `__mode` string, values are considered weak.
>
> Weak references do not contribute to the amount of active references a value has which means
> they cannot stop a value from being garbage collected.
>
> When the value a weak reference points to is collected by the garbage collector, the entry in
> the table that contains the weak reference is completely removed.
>
> > ***Note:** Due to LuaJ using Java's garbage collector, this might not actually work as
> > intended.*
***
&nbsp;  
&nbsp;
***
> ```lua
> (field) __metatable: any
> ```
> ***
> This metamethod controls access to the metatable of a table.
>
> If this is set to anything other than `nil`, any attempt to use `getmetatable()` on the table
> will instead return the value in the `__metatable` metamethod.  
> Attempting to use `setmetatable()` on the table will also throw an error.
>
> An example of hiding the metatable of a table.
> > ```lua
> > local Object = {}
> > setmetatable(Object, {__metatable = false})
> >
> > print(getmetatable(Object)) --> false
> > setmetatable(Object, {})    --> [error] cannot change a protected metatable
> > ```
***
&nbsp;  
&nbsp;
***
> ```lua
> function __tostring(self: <self>)
>   -> string: string
> ```
> ***
> This metamethod controls the result of using `tostring()` on a table.
>
> While this metamethod can return any value, it is recommended to return a string in all cases.
>
> > ***Note:** `print()` and `error()` in Figura do **not** respect this metamethod and will not
> > use it when getting the string representation of the table.*
>
> An example of a valid `__tostring` metamethod that gives a table a more descriptive name.
> > ```lua
> > local MyClass = {}
> > setmetatable(MyClass, {
> >   __tostring = function() return "MyClass" end
> > })
> >
> > local mytable = {}
> >
> > print(tostring(mytable))) --> table: 54bb368a
> > print(tostring(MyClass))) --> MyClass
> > ```
***
&nbsp;  
&nbsp;
***
> ```lua
> function __pairs(self: <self>)
>   -> iterator: fun(tbl: table, key: any): (next_key: any), (next_value: any)
>   2. tbl: table
>   2. starting_key: any
> ```
> ***
> This metamethod controls how `pairs()` iterates over a table.
>
> The metamethod must return 3 values:
> * **`iterator`**  
>   The function that the `for of` loop will run when it loops.  
>   The first parameter is the object to iterate over. The iterator is not required to use it.  
>   The second parameter is the key that was previously iterated over.  
>   The iterator should return a key and value which are passed into the `for of` loop.  
>   The iterator should return nothing if there is no next key or value.
> * **`tbl`**  
>   The object that should be iterated over. This is passed as the first parameter of `iterator`.  
>   This object doesn't actually have to be iterated over. The iterator can choose to ignore it.
> * **`starting_key`**  
>   The first key the iterator should receive. By default this is `nil`.
>
> An example iterator that loops over a contained "data" folder instead of itself.
> > ```lua
> > local DataContainer = {
> >   data = {
> >     hello = "world",
> >     foo = "bar",
> >     abc = "xyz"
> >   }
> > }
> > setmetatable(DataContainer, {
> >   __pairs = function(self)
> >     local function iter(_, key)
> >       local k, v = next(self.data, key)
> >       if k then return k, v end
> >     end
> >
> >     return iter, self, nil
> >   end
> > })
> >
> > for k, v in pairs(DataContainer) do
> >   print(k, v) --> hello  world
> >               --> foo  bar
> >               --> abc  xyz
> > end
> > ```
***
&nbsp;  
&nbsp;
***
> ```lua
> function __ipairs(self: <self>)
>   -> iterator: fun(tbl: table, key: integer): (next_key: integer), (next_value: any)
>   2. tbl: table
>   2. starting_key: integer
> ```
> ***
> This metamethod controls how `ipairs()` iterates over a table.
>
> This metamethod behaves almost exactly like `__pairs` but affects `ipairs()` instead.  
> Refer to the info on `__pairs` to learn more.
***
&nbsp;  
&nbsp;
***
> ```lua
> (field) __type: string
> ```
> ***
> ### *Non-standard*
> This metamethod controls what `type()` returns when used on a table.
>
> By default, `type()` will return `"table"` when used on a table. This metamethod allows
> changing that to any string to allow the table to have a "custom" type.
>
> An example of a valid `__type` metamethod that adds a custom type to a table.
> > ```lua
> > local MyClass = {}
> > setmetatable(MyClass, {__type = "MyClass"})
> >
> > print(type(MyClass)) --> MyClass
> > ```
***
&nbsp;  
&nbsp;
***
> ```lua
> function __len(self: <self>)
>   -> length: integer
> ```
> ***
> This metamethod controls what the `#` operator returns when used on a table.
>
> An example of a valid `__len` metamethod that gets the size of a range.
> > ```lua
> > local Range = {min = 5, max = 13}
> > setmetatable(Range, {
> >   __len = function(self)
> >     return self.max - self.min + 1
> >   end
> > })
> >
> > print(#Range) --> 9
> > ```
***
&nbsp;  
&nbsp;
***
> ```lua
> function __unm(self: <self>)
>   -> inverse: any
> ```
> ***
> This metamethod controls what the unary `-` operator returns when used on a table.
>
> An example of a valid `__unm` metamethod that flips a position coordinate.
> > ```lua
> > local Position = {x = 25, y = 13, z = -64}
> > setmetatable(Position, {
> >   __unm = function(self)
> >     return setmetatable({x = -self.x, y = -self.y, z = -self.z}, getmetatable(self))
> >   end
> > })
> >
> > print(Position)  --> {x = 25, y = 13, z = -64}
> > print(-Position) --> {x = -25, y = -13, z = 64}
> > ```
***
&nbsp;  
&nbsp;
***
> ```lua
> function __add(left: any, right: any)
>   -> sum: any
> ```
> ***
> This metamethod controls what the `+` operator returns when used on a table.
>
> If two tables are being added, the metamethod of the left table is used if it exists. The right
> table's metamethod is used otherwise.
>
> As the names of the parameters suggest, the first parameter isn't always the table that
> contains the metamethod. Instead, it is always the *left-hand side* of the operation.
>
> An example of a valid `__add` metamethod that combines two complex numbers.
> > ```lua
> > local ComplexMT = {
> >   __add = function(l, r)
> >     return setmetatable({n = l.n + r.n, i = l.i + r.i}, getmetatable(l))
> >   end
> > }
> > local Complex1 = setmetatable({n = 2, i = 3}, ComplexMT)
> > local Complex2 = setmetatable({n = 1, i = 5}, ComplexMT)
> >
> > print(Complex1)            --> (2+3i)
> > print(Complex1 + Complex2) --> (3+8i)
> > ```
***
&nbsp;  
&nbsp;
***
> ```lua
> function __sub(left: any, right: any)
>   -> difference: any
> ```
> ***
> This metamethod controls what the binary `-` operator returns when used on a table.
>
> The same rules as `__add` are followed.
>
> An example of a valid `__sub` metamethod that subtracts substrings from a bigger string.
> > ```lua
> > local CustomString = {value = "hello world"}
> > setmetatable(CustomString, {
> >   __sub = function(l, r)
> >     return setmetatable({value = l.value:gsub(r, "")}, getmetatable(l))
> >   end
> > })
> >
> > print(CustomString)               --> {"hello world"}
> > print(CustomString - "o")         --> {"hell wrld"}
> > print(CustomString - "he" - "or") --> {"llo wld"}
> > ```
***
&nbsp;  
&nbsp;
***
> ```lua
> function __mul(left: any, right: any)
>   -> product: any
> ```
> ***
> This metamethod controls what the `*` operator returns when used on a table.
>
> The same rules as `__add` are followed.
>
> An example of a valid `__mul` metamethod that repeats a string.
> > ```lua
> > local CustomString = {value = "foo"}
> > setmetatable(CustomString, {
> >   __mul = function(l, r)
> >     if type(l) == "number" then l, r = r, l end
> >     return setmetatable({value = l.value:rep(r)}, getmetatable(l))
> >   end
> > })
> >
> > print(CustomString)     --> {"foo"}
> > print(CustomString * 5) --> {"foofoofoofoofoo"}
> > print(2 * CustomString) --> {"foofoo"}
> > ```
***
&nbsp;  
&nbsp;
***
> ```lua
> function __div(left: any, right: any)
>   -> quotient: any
> ```
> ***
> This metamethod controls what the `/` operator returns when used on a table.
>
> The same rules as `__add` are followed.
>
> An example of a valid `__div` metamethod that concatenates paths together.
> > ```lua
> > local PathMT = {
> >   __div = function(l, r)
> >     return setmetatable({path = l.path .. "/" .. r.path:gsub("^/", "")}, getmetatable(l))
> >   end
> > }
> > local Path1 = setmetatable({path = "/foo/bar"}, PathMT)
> > local Path2 = setmetatable({path = "/hello/world"}, PathMT)
> >
> > print(Path1)       --> /foo/bar
> > print(Path2)       --> /hello/world
> > print(Path1/Path2) --> /foo/bar/hello/world
> > ```
***
&nbsp;  
&nbsp;
***
> ```lua
> function __mod(left: any, right: any)
>   -> remainder: any
> ```
> ***
> This metamethod controls what the `%` operator returns when used on a table.
>
> The same rules as `__add` are followed.
>
> An example of a valid `__mod` metamethod that causes an action to have a chance of running.
> > ```lua
> > local Action = {chance = 1, action = function() print("hi!") end}
> > setmetatable(Action, {
> >   __mod = function(l, r)
> >     if type(l) == "number" then l, r = r, l end
> >     return setmetatable({chance = l.chance * (r / 100), action = l.action}, getmetatable(l))
> >   end,
> >   __call = function(self, ...)
> >     if math.random() <= self.chance then self.action(...) end
> >   end
> > })
> >
> > Action()         --> hi!
> >
> > local RareAction = 20 % Action
> > RareAction()     --> [20% chance to print "hi!", 80% chance to print nothing]
> >
> > local LessRareAction = 200% RareAction
> > LessRareAction() --> [40% chance to print "hi!", 60% chance to print nothing]
> > ```
***
&nbsp;  
&nbsp;
***
> ```lua
> function __pow(left: any, right: any)
>   -> power: any
> ```
> ***
> This metamethod controls what the `^` operator returns when used on a table.
>
> The same rules as `__add` are followed.
>
> An example of a valid `__pow` metamethod that adds superscript text to a string.
> > ```lua
> > local CustomString = {value = "e = mc"}
> >
> > local supers = {
> >   ["1"] = "¹", ["2"] = "²", ["3"] = "³", ["4"] = "⁴", ["5"] = "⁵", ["6"] = "⁶", ["7"] = "⁷",
> >   ["8"] = "⁸", ["9"] = "⁹", ["0"] = "⁰", ["+"] = "⁺", ["n"] = "ⁿ"
> > }
> >
> > setmetatable(CustomString, {
> >   __pow = function(l, r)
> >     return setmetatable({value = l.value .. r:gsub(".", supers)}, getmetatable(l))
> >   end
> > })
> >
> > print(CustomString)       --> {"e = mc"}
> > print(CustomString ^ "2") --> {"e = mc²"}
> > ```
***
&nbsp;  
&nbsp;
***
> ```lua
> function __concat(left: any, right: any)
>   -> merged: any
> ```
> ***
> This metamethod controls what the `..` operator returns when used on a table.
>
> Similar rules as `__add` are followed. However, the order that tables are checked for a
> metamethod is reversed. The right side is checked first, and then the left is checked.
>
> An example of a valid `__concat` metamethod that creates a range from two other ranges.
> > ```lua
> > local RangeMT = {
> >   __concat = function(left, right)
> >     return setmetatable({
> >       min = math.min(l.min, r.min),
> >       max = math.max(l.max, r.max)
> >     }, getmetatable(l))
> >   end
> > }
> > local Range1 = setmetatable({min = 2, max = 15}, RangeMT)
> > local Range2 = setmetatable({min = 12, max = 22}, RangeMT)
> >
> > print(Range1)           --> [2 .. 15]
> > print(Range2)           --> [12 .. 22]
> > print(Range1 .. Range2) --> [2 .. 22]
> > ```
***
&nbsp;  
&nbsp;
***
> ```lua
> function __eq(left: any, right: any)
>   -> result: any
> ```
> ***
> This metamethod controls what the `==` operator returns when used on a table.
>
> Similar rules as `__add` are followed. However, *both* tables must use the same exact `__eq`
> metamethod for it to work, otherwise the default equality check is done.  
> (Note that even if two functions have the same body contents, they are *not* equal. A function
> is only ever equal to itself.)
>
> If both tables are the same exact table, the metamethod is ignored in favor of always returning
> `true`.
>
> An example of a valid `__eq` metamethod that checks if two complex objects are equal.
> > ```lua
> > local ObjectMT = {
> >   __eq = function(left, right)
> >     return left.foo == right.foo and left.bar == right.bar
> >   end
> > }
> > local Object1 = setmetatable({foo = 1, bar = 2}, ObjectMT)
> > local Object2 = setmetatable({foo = 1, bar = 5}, ObjectMT)
> >
> > print(Object1 == Object2) --> false
> >
> > Object2.bar = 2
> > print(Object1 == Object2) --> true
> > ```
***
&nbsp;  
&nbsp;
***
> ```lua
> function __lt(left: any, right: any)
>   -> result: any
> ```
> ***
> This metamethod controls what the `<` and `>` operators return when used on a table.
>
> The same rules as `__add` are followed.
>
> If doing a greater-than comparison, the left and right values switch sides before being sent to
> this metamethod.
>
> An example of a valid `__lt` metamethod that checks if all of the values in the table are
> smaller than the values of the other table.
> > ```lua
> > local CompareAllMT = {
> >   __lt = function(l, r)
> >     for k of pairs(l) do
> >       if l[k] >= (r[k] or 0) then return false end
> >     end
> >     return true
> >   end
> > }
> > local CompareAll1 = setmetatable({hello = 7, world = 1, foo = -5, bar = -0.2}, CompareAllMT)
> > local CompareAll2 = setmetatable({hello = 1, world = 7, foo = -4}, CompareAllMT)
> >
> > print(CompareAll1 < CompareAll2) --> false
> >
> > CompareAll2.hello = 9
> > print(CompareAll1 < CompareAll2) --> true
> > ```
***
&nbsp;  
&nbsp;
***
> ```lua
> function __lt(left: any, right: any)
>   -> result: any
> ```
> ***
> This metamethod controls what the `<=` and `>=` operators return when used on a table.
>
> The same rules as `__add` are followed.
>
> If doing a greater-than-or-equal-to comparison, the left and right values switch sides before
> being sent to this metamethod.
>
> An example of a valid `__le` metamethod that checks if all of the values in the table are
> smaller than or equal to the values of the other table.
> > ```lua
> > local CompareAllMT = {
> >   __le = function(l, r)
> >     for k of pairs(l) do
> >       if l[k] > (r[k] or 0) then return false end
> >     end
> >     return true
> >   end
> > }
> > local CompareAll1 = setmetatable({hello = 7, world = 1, foo = -5, bar = 0}, CompareAllMT)
> > local CompareAll2 = setmetatable({hello = 1, world = 7, foo = -5}, CompareAllMT)
> >
> > print(CompareAll1 <= CompareAll2) --> false
> >
> > CompareAll2.hello = 7
> > print(CompareAll1 <= CompareAll2) --> true
> > ```


```lua
table
```


---

# first_person_model

`first_person_model` is deprecated. It has no replacement.


```lua
nil
```


---

# getmetatable

If object does not have a metatable, returns nil. Otherwise, if the object's metatable has a
__metatable field, returns the associated value. Otherwise, returns the metatable of the given
object.

[View documents](command:extension.lua.doc?["en-us/52/manual.html/pdf-getmetatable"])


```lua
function getmetatable(object: any)
  -> metatable: table
```


---

# held_item_model

`held_item_model` is deprecated. Replace the following:
* `held_item_model.LEFT_HAND` with `vanilla_model.LEFT_ITEM`
* `held_item_model.RIGHT_HAND` with `vanilla_model.RIGHT_ITEM`

&nbsp;
### IF `HELD_ITEM_MODEL` IS PART OF A `FOR IN` LOOP...
```lua
for _, v in pairs(held_item_model) do
  v.setEnabled(<state>)
end
```
The ***entire loop*** should be replaced with
```lua
vanilla_model.HELD_ITEMS:setVisible(<state>)
```


```lua
nil
```


---

# host


```lua
HostAPI
```


---

# ipairs

Returns three values (an iterator function, the table `t`, and `0`) so that the construction
```lua
    for i,v in ipairs(t) do body end
```
will iterate over the key-value pairs `(1,t[1]), (2,t[2]), ...`, up to the first absent index.

[View documents](command:extension.lua.doc?["en-us/52/manual.html/pdf-ipairs"])


```lua
function ipairs(t: <T:table>)
  -> fun(table: <V>[], i?: integer):integer, <V>
  2. <T:table>
  3. i: integer
```


---

# item_stack

`item_stack` is deprecated. Replace the following:
* `item_stack.createItem()` with `world.newItem()`


```lua
nil
```


---

# keybind

`keybind` is deprecated. To get the keybind API, use `keybinds`.


```lua
nil
```


---

# keybinds

An API for handling custom keybinds.

> ***

Create a new keybind with:
```lua
local kb_var = <KeybindAPI>:newKeybind("Keybind Name", "key.keyboard.keycode")
```
Keybinds can be bound to run lua code with:
```
function kb_var:onPress(function()
  print("hello world")
end)

function kb_var:onRelease(function()
  print("goodbye world")
end)
```


```lua
KeybindAPI
```


---

# listFiles

Gets a list of all script files in the given directory.  
Searches the avatar root if no dir is given.

If `recursive` is set, files in subdirectories will be listed.


```lua
function listFiles(dir?: string, recursive?: boolean)
  -> string[]
```


---

# load

An alias of `loadstring`.
> ***
> Loads a chunk from the given string.
>
> If a chunk name is given, it is used in error messages involving the created chunk.  
> If an environment is given, it is treated as the `_ENV` of the created chunk.
> ***

~~[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-load"])~~  
This function has been modified by Figura and does not work how it does in normal Lua 5.2.


```lua
function load(text: string, chunkname?: string, env?: table)
  -> function?
  2. error_message: string?
```


---

# loadstring

Loads a chunk from the given string.

If a chunk name is given, it is used in error messages involving the created chunk.  
If an environment is given, it is treated as the `_ENV` of the created chunk.

~~[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-loadstring"])~~  
This function does not exist in normal Lua 5.2 and is somewhat similar to the Lua 5.1 function of
the same name.


```lua
function loadstring(text: string, chunkname?: string, env?: table)
  -> function?
  2. error_message: string?
```


---

# log

Alias of `print`.
> ***
> Receives any number of arguments and prints them to chat seperated by two spaces.  
> If a string value is given, it will be printed as-is with no formatting.
>
> If a non-string value is given, the value will be formatted in a readable manner and given a
> special color depending on the type.
> * `nil`: Red,
> * `boolean`: Purple,
> * `number`: Cyan,
> * `function`: Green,
> * `table`: Blue,
> * `userdata`: Yellow.
> ***


```lua
function log(...any)
  -> string
```


---

# logJson

Alias of `printJson`.
> ***
> Receives any number of arguments and prints them to chat without a seperator.  
> If a string value is given, it will be parsed as a Raw JSON Text component.
>
> This function does not print the standard log prefix.
> ***


```lua
function logJson(...any)
  -> string
```


---

# logTable

Alias of `printTable`.
> ***
> Prints the contents of the given table or userdata object to chat down to the specified depth.\
> If a userdata object is given, every default Figura method and field on it is printed.
>
> If a non-table value is given, it is printed similar to `print`. (Except for strings, which get
> double quotes around them.)
>
> If `silent` is set, the table will not be printed to chat, but will still be returned as a
> string.
> ***

If `depth` is `nil`, it will default to `1`.  
If `silent` is `nil`, it will default to `false`.


```lua
function logTable(t: any, depth?: integer, silent?: boolean)
  -> string
```


---

# math




[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math"])



```lua
mathlib
```


---

# math.abs


Returns the absolute value of `x`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.abs"])


```lua
function math.abs(x: <Number:number>)
  -> <Number:number>
```


---

# math.acos


Returns the arc cosine of `x` (in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.acos"])


```lua
function math.acos(x: number)
  -> number
```


---

# math.asin


Returns the arc sine of `x` (in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.asin"])


```lua
function math.asin(x: number)
  -> number
```


---

# math.atan


Returns the arc tangent of `x` (in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.atan"])


```lua
function math.atan(y: number)
  -> number
```


---

# math.atan2


Returns the arc tangent of `y/x` (in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.atan2"])


```lua
function math.atan2(y: number, x: number)
  -> number
```


---

# math.ceil


Returns the smallest integral value larger than or equal to `x`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.ceil"])


```lua
function math.ceil(x: number)
  -> integer
```


---

# math.clamp

Restricts the value given to be between the other two numbers.


```lua
function math.clamp(x: number, min: number, max: number)
  -> number
```


---

# math.cos


Returns the cosine of `x` (assumed to be in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.cos"])


```lua
function math.cos(x: number)
  -> number
```


---

# math.cosh


Returns the hyperbolic cosine of `x` (assumed to be in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.cosh"])


```lua
function math.cosh(x: number)
  -> number
```


---

# math.deg


Converts the angle `x` from radians to degrees.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.deg"])


```lua
function math.deg(x: number)
  -> number
```


---

# math.exp


Returns the value `e^x` (where `e` is the base of natural logarithms).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.exp"])


```lua
function math.exp(x: number)
  -> number
```


---

# math.floor


Returns the largest integral value smaller than or equal to `x`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.floor"])


```lua
function math.floor(x: number)
  -> integer
```


---

# math.fmod


Returns the remainder of the division of `x` by `y` that rounds the quotient towards zero.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.fmod"])


```lua
function math.fmod(x: number, y: number)
  -> number
```


---

# math.frexp


Decompose `x` into tails and exponents. Returns `m` and `e` such that `x = m * (2 ^ e)`, `e` is an integer and the absolute value of `m` is in the range [0.5, 1) (or zero when `x` is zero).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.frexp"])


```lua
function math.frexp(x: number)
  -> m: number
  2. e: number
```


---

# math.ldexp


Returns `m * (2 ^ e)` .

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.ldexp"])


```lua
function math.ldexp(m: number, e: number)
  -> number
```


---

# math.lerp

Linearly interpolates between two numbers, vectors, or matrices.

Numbers, vectors, and matrices can go in *any* of the three parameters, but only *one* type of
vector or matrix may be used maximum.  
If any vector type is used, the return will be the type of that vector.
```html
<a>(3)
 ╤     0 = 3
 ┼
 ┼
 ╪ <t> 0.5 = 5.5
 ┼
 ┼
 ╧     1 = 8
<b>(8)
```


```lua
function math.lerp(a: <A:number|Matrix.any|Vector.any>, b: <B:number|Matrix.any|Vector.any>, t: <T:number|Matrix.any|Vector.any>)
  -> number|<A:number|Matrix.any|Vector.any>|<B:number|Matrix.any|Vector.any>|<T:number|Matrix.any|Vector.any>
```


---

# math.lerpAngle

Linearly interpolates between two number angles, vector angles, or matrices.  
The shortest path to the destination angle will always be taken, even if it ends up with the
result being out of the 0 to 360 (or -180 to 180) bounds.

The final number will be reduced modulo 360.

Numbers, vectors, and matrices can go in *any* of the three parameters, but only *one* type of
vector or matrix may be used maximum.  
If any vector type is used, the return will be the type of that vector.
```html
             ,--- <a>(60°)
    ,-"""""-/      ╤     0 = 60°
  ,'       / `.    ┼
 /        /    \   ┼
|        /      |  ╪ <t> 0.5 = 7.5°
|        `.     |  ┼
 \         `.  /   ┼
  `.         `.    ╧     1 = 315°
    `-_____-'  `- <b>(315°)


```


```lua
function math.lerpAngle(a: <A:number|Matrix.any|Vector.any>, b: <B:number|Matrix.any|Vector.any>, t: <T:number|Matrix.any|Vector.any>)
  -> number|<A:number|Matrix.any|Vector.any>|<B:number|Matrix.any|Vector.any>|<T:number|Matrix.any|Vector.any>
```


---

# math.log


Returns the logarithm of `x` in the given base.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.log"])


```lua
function math.log(x: number, base?: integer)
  -> number
```


---

# math.log10


Returns the base-10 logarithm of x.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.log10"])


```lua
function math.log10(x: number)
  -> number
```


---

# math.map

Converts a number, vector, or matrix from one range to another.

Numbers, vectors, and matrices can go in *any* of the five parameters, but only *one* type of
vector or matrix may be used maximum.  
If any vector or matrix type is used, the return will be the type of that vector or matrix.
```html
 (0)  v     v   v   (12)
<aMin>╟─┼─┼─╫─┼─┼─╢<aMax>
      0     6   10
      ↓     ↓   ↓
      32    48  58.67
<bMin>╟─┼─┼─╫─┼─┼─╢<bMax>
 (32)               (64)
```


```lua
function math.map(v: <V:number|Matrix.any|Vector.any>, aMin: <A1:number|Matrix.any|Vector.any>, aMax: <A2:number|Matrix.any|Vector.any>, bMin: <B1:number|Matrix.any|Vector.any>, bMax: <B2:number|Matrix.any|Vector.any>)
  -> number|<A1:number|Matrix.any|Vector.any>|<A2:number|Matrix.any|Vector.any>|<B1:number|Matrix.any|Vector.any>|<B2:number|Matrix.any|Vector.any>|<V:number|Matrix.any|Vector.any>
```


---

# math.max


Returns the argument with the maximum value, according to the Lua operator `<`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.max"])


```lua
function math.max(x: <Number:number>, ...<Number:number>)
  -> <Number:number>
```


---

# math.min


Returns the argument with the minimum value, according to the Lua operator `<`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.min"])


```lua
function math.min(x: <Number:number>, ...<Number:number>)
  -> <Number:number>
```


---

# math.modf


Returns the integral part of `x` and the fractional part of `x`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.modf"])


```lua
function math.modf(x: number)
  -> integer
  2. number
```


---

# math.playerScale

The factor by which the player is scaled down before being rendered into the world.


```lua
number
```


---

# math.pow


Returns `x ^ y` .

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.pow"])


```lua
function math.pow(x: number, y: number)
  -> number
```


---

# math.rad


Converts the angle `x` from degrees to radians.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.rad"])


```lua
function math.rad(x: number)
  -> number
```


---

# math.random


* `math.random()`: Returns a float in the range [0,1).
* `math.random(n)`: Returns a integer in the range [1, n].
* `math.random(m, n)`: Returns a integer in the range [m, n].


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.random"])


```lua
function math.random(m: integer, n: integer)
  -> integer
```


---

# math.randomseed


Sets `x` as the "seed" for the pseudo-random generator.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.randomseed"])


```lua
function math.randomseed(x: integer)
```


---

# math.round

Rounds the given value to the nearest integer.


```lua
function math.round(x: number)
  -> integer
```


---

# math.shortAngle

Gets the shortest angle between two numbers or vectors.

The shortest path to the destination angle will always be taken, even if it ends up with the
result being out of the -180 to 180 (or 0 to 360) bounds.

Numbers and vectors can go in *any* of the two parameters, but only *one* type of vector may be
used maximum.  
If any vector type is used, the return will be the type of that vector.


```lua
function math.shortAngle(a: <A:number|Matrix.any|Vector.any>, b: <B:number|Matrix.any|Vector.any>)
  -> number|<A:number|Matrix.any|Vector.any>|<B:number|Matrix.any|Vector.any>
```


---

# math.sign

Gets the sign of the given value.

* All positive numbers return `1`
* All negative numbers return `-1`
* `0` returns `0`
* `NaN` returns `-1`

```lua
return #1:
    | -1 -- Negative / NaN
    | 0 -- Zero
    | 1 -- Positive
```


```lua
function math.sign(x: number)
  -> -1|0|1
```


---

# math.sin


Returns the sine of `x` (assumed to be in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.sin"])


```lua
function math.sin(x: number)
  -> number
```


---

# math.sinh


Returns the hyperbolic sine of `x` (assumed to be in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.sinh"])


```lua
function math.sinh(x: number)
  -> number
```


---

# math.sqrt


Returns the square root of `x`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.sqrt"])


```lua
function math.sqrt(x: number)
  -> number
```


---

# math.tan


Returns the tangent of `x` (assumed to be in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.tan"])


```lua
function math.tan(x: number)
  -> number
```


---

# math.tanh


Returns the hyperbolic tangent of `x` (assumed to be in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.tanh"])


```lua
function math.tanh(x: number)
  -> number
```


---

# math.tointeger


Miss locale <math.tointeger>

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.tointeger"])


```lua
function math.tointeger(x: any)
  -> integer?
```


---

# math.type


Miss locale <math.type>

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.type"])


```lua
return #1:
    | "integer"
    | "float"
    | 'nil'
```


```lua
function math.type(x: any)
  -> "float"|"integer"|'nil'
```


---

# math.ult


Miss locale <math.ult>

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.ult"])


```lua
function math.ult(m: integer, n: integer)
  -> boolean
```


---

# math.worldScale

A number that will reverse the `.playerScale` factor.

This number is *slightly* off from the exact value. To get the exact value, use
`1 / math.playerScale`.


```lua
number
```


---

# matrices

An API for working with matrices.

> ***

Create a new matrix with:
```lua
local mat2 = <MatricesAPI>.mat2(
  vec(x1, x2),
  vec(y1, y2)
)

local mat3 = <MatricesAPI>.mat3(
  vec(x1, x2, x3),
  vec(y1, y2, y3),
  vec(z1, z2, z3)
)

local mat4 = <MatricesAPI>.mat4(
  vec(x1, x2, x3, x4),
  vec(y1, y2, y3, y4),
  vec(z1, z2, z3, z4),
  vec(w1, w2, w3, w4)
)
```
Matrix4s are the most common type of matrix. They are often used to transform part positions to
world positions.

To get a transformed position from a Matrix4, use:
```lua
local newPos = <Matrix4>:apply(x, y, z)
```


```lua
MatricesAPI
```


---

# meta

`meta` is deprecated. Replace the following:
* `meta.getAnimationLimit()` with `avatar:getMaxAnimationComplexity()`
* `meta.getCanModifyNameplate()` with `avatar:canEditNameplate()`
* `meta.getCanModifyVanilla()` with `avatar:canEditVanillaModel()`
* `meta.getComplexityLimit()` with `avatar:getMaxComplexity()`
* `meta.getCurrentAnimationCount()` with `avatar:getAnimationComplexity()`
* `meta.getCurrentComplexity()` with `avatar:getComplexity()`
* `meta.getCurrentParticleCount()` with `avatar:getRemainingParticles()`
* `meta.getCurrentRenderCount()` with `avatar:getRenderCount()`/`avatar:getCurrentInstructions()`
* `meta.getCurrentSoundCount()` with `avatar:getRemainingSounds()`
* `meta.getCurrentTickCount()` with `avatar:getTickCount()`/`avatar:getCurrentInstructions()`
* `meta.getDoesRenderOffscreen()` with `avatar:canRenderOffscreen()`
* `meta.getFiguraVersion()` with `client.getFiguraVersion()`
* `meta.getInitLimit()` with `avatar:getMaxInitCount()`
* `meta.getParticleLimit()` with `avatar:getMaxParticles()`
* `meta.getRenderLimit()` with `avatar:getMaxRenderCount()`
* `meta.getScriptStatus()` with `avatar:hasScriptError()`
* `meta.getSoundLimit()` with `avatar:getMaxSounds()`
* `meta.getTextureStatus()` with `avatar:hasTexture()`
* `meta.getTickLimit()` with `avatar:getMaxTickCount()`

The following do not have a replacement:
* `meta.getBackendStatus()`
* `meta.getCanHaveCustomRenderLayer()`
* `meta.getModelStatus()`


```lua
nil
```


---

# model

`model` is deprecated. To get all model parts in this avatar, use `models`.

Avatars can have multiple model files, which means models are accessed by indexing `models` with the name of the
bbmodel file.  
(To get the model parts from `mycoolmodel.bbmodel`, do `models.mycoolmodel`.)


```lua
nil
```


---

# models

A part of the avatar's model.  
This can be a group, cube, or mesh.

> ***

To access the parts of an avatar, start with:
```lua
models.<bbmodel_name>.<path.to.part.here>
```
then start making a path to the target part.

As an example, to target the part path shown below...  
> 📄 `MyModel.bbmodel`  
> &emsp;📁 `Head`  
> &emsp;&emsp;📁 `Hat`  
> &emsp;&emsp;&emsp;⬛ `Brim`

use the following:
```lua
models.MyModel.Head.Hat.Brim
```
&emsp;  
When naming model parts, a part name that is not a valid identifier or matches a Lua keyword
requires an alternate way of accessing the part.

If a part is named `and`, it will conflict with the Lua keyword `and`.
```lua
models.MyModel.and    -- Causes an error, Lua did not expect a keyword here.
models.MyModel["and"] -- Does not error, the keyword is contained in a string.
```
If a part starts with a number, it will fail due to Lua trying to read the number first.
```lua
models.MyModel.42bottles    -- Causes an error, Lua did not expect a number here.
models.MyModel["42bottles"] -- Does not error, the number is contained in a string.
```
<!--


```lua
ModelPart
```


---

# nameplate

A container for the nameplates.


```lua
NameplateAPI
```


---

# network

`network` is *very* deprecated.

`network.registerPing()` and the connected global function are now replaced with
```lua
function pings.pingNameHere(param1, param2, ...)
  --your code here.
end
```
and `network.ping()` is replaced with
```lua
pings.pingNameHere(arg1, arg2, ...)
```


```lua
nil
```


---

# next

Allows a program to traverse all fields of a table. Its first argument is a table and its second
argument is an index in this table. A call to `next` returns the next index of the table and its
associated value. When called with `nil` as its second argument, `next` returns an initial index
and its associated value. When called with the last index, or with `nil` in an empty table,
`next` returns `nil`. If the second argument is absent, then it is interpreted as `nil`.
In particular, you can use `next(t)` to check whether a table is empty.

The order in which the indices are enumerated is not specified, *even for numeric indices*. (To
traverse a table in numerical order, use a numerical `for`.)

The behavior of `next` is undefined if, during the traversal, you assign any value to a
non-existent field in the table. You may however modify existing fields. In particular, you may
set existing fields to nil.

[View documents](command:extension.lua.doc?["en-us/52/manual.html/pdf-next"])


```lua
function next(table: table<<K>, <V>>, index?: <K>)
  -> <K>?
  2. <V>?
```


---

# pairs

If `t` has a metamethod `__pairs`, calls it with t as argument and returns the first three
results from the call.

Otherwise, returns three values: the
[next](command:extension.lua.doc?["en-us/52/manual.html/pdf-next"]) function, the table `t`, and
`nil`, so that the construction
```lua
    for k,v in pairs(t) do body end
```
will iterate over all key-value pairs of table `t`.

See function [next](command:extension.lua.doc?["en-us/52/manual.html/pdf-next"]) for the caveats
of modifying the table during its traversal.

[View documents](command:extension.lua.doc?["en-us/52/manual.html/pdf-pairs"])


```lua
function pairs(t: <T:table>)
  -> fun(table: table<<K>, <V>>, index?: <K>):<K>, <V>
  2. <T:table>
```


---

# parrot_model

`parrot_model` is deprecated. Replace the following:
* `parrot_model.LEFT_PARROT` with `vanilla_model.LEFT_PARROT`
* `parrot_model.RIGHT_PARROT` with `vanilla_model.RIGHT_PARROT`

&nbsp;
### IF `PARROT_MODEL` IS PART OF A `FOR IN` LOOP...
```lua
for _, v in pairs(parrot_model) do
  v.setEnabled(<state>)
end
```
The ***entire loop*** should be replaced with
```lua
vanilla_model.PARROTS:setVisible(<state>)
```


```lua
nil
```


---

# parseJson

Converts a JSON string into the appropriate Lua value.


```lua
function parseJson(json: string)
  -> (boolean|string|number|table)?
```


---

# particle

`particle` is deprecated. Replace the following:
* `particle.addParticle()` with `particles:newParticle()`


```lua
nil
```


---

# particles

An API for handling particle effects.


```lua
ParticleAPI
```


---

# pcall

Calls the function `f` with the given arguments in *protected mode*. This means that any error
inside `f` is not propagated; instead, `pcall` catches the error and returns a status code. Its
first result is the status code (a boolean), which is true if the call succeeds without errors.
In such case, `pcall` also returns all results from the call, after this first result. In case of
any error, `pcall` returns `false` plus the error object.

[View documents](command:extension.lua.doc?["en-us/52/manual.html/pdf-pcall"])


```lua
function pcall(f: function, ...any)
  -> success: boolean
  2. result: any
  3. ...any
```


---

# ping

`ping` is deprecated. To get or modify the pings this avatar has, use `pings`.


```lua
nil
```


---

# pings

A table containing an avatar's ping functions.

> ***

Ping functions allow sending information that other clients may not have access to.  
Things such as:
* Worn equipment
* Player health
* Changing model UV
* Playing a sound

do not need to be pinged as all clients can understand these functions or objects.

Things such as:
* Clicking or scrolling the action wheel
* Pressing a keybind
* Player inventory contents
* Host checks

*do* need to be pinged as other clients do not understand these functions or objects.

Consider the following code:
```lua
if myKey:isPressed() then
  print("Hello world!")
else
  print("Goodbye world!")
end
```
Since other clients don't know when a keybind is pressed, they will never run the `if` block.
```lua
<HOST>                       <CLIENT>
├•if myKey:isPressed() then  │ if myKey:isPressed() then
├•  print("Hello world!")    │   print("Hello world!")
│ else                       ├•else
│   print("Goodbye world!")  ├•  print("Goodbye world!")
└•end                        └•end
```
&emsp;  
Pings allow other clients to run code that would normally be unreachable for them.
```lua
function pings.coolPing(x)
  if x then
    print("Hello world!")
  else
    print("Goodbye world!")
  end
end

if host:isHost() then
  if myKey:isPressed() then
    pings.coolPing(true)
  else
    pings.coolPing(false)
  end
end
```
The ping will resync the host and client when it is reached. Allowing other clients to know when
a keybind is pressed, for example.
```lua
<HOST>                         <CLIENT>
├•if host:isHost() then        │ if host:isHost() then
├•  if myKey:isPressed() then  │   if myKey:isPressed() then
├¶    pings.coolPing(true)     │     pings.coolPing(true)
│   else                       │   else
│     pings.coolPing(false)    │     pings.coolPing(false)
├•  end                        │   end
└•end                          ╵ end

¶                              ¶
├•function pings.coolPing(x)   ├•function pings.coolPing(x)
├•  if x then                  ├•  if x then
├•    print("Hello world!")    ├•    print("Hello world!")
│   else                       │   else
│     print("Goodbye world!")  │     print("Goodbye world!")
├•  end                        ├•  end
└•end                          └•end
```
&emsp;  
Custom-made functions are not an exception. If a ping contains one, it will run its entire
contents like normal.
```lua
<HOST>                                     <CLIENT>
├• function pings.coolPing()               ├•function pings.coolPing()
├•   print("Hello World!")                 ├•  print("Hello World!")
├¹   myFunction()                          ├²  myFunction()
└• end                                     └•end

1                                          2
├• function myFunction()                   ├•function myFunction()
├•   models.MyModel.Head:setVisible(false) ├•  models.MyModel.Head:setVisible(false)
└• end                                     └•end
```
&emsp;  
Pings do have limits. They do not cause clients to magically think they are the host. They are
still limited by what they know.
```lua
function pings.coolPing()
  print("Hello World!")
  models.MyModel.Head:setVisible(false)
  myCoolFunction()

  if host:isHost() then
    print("Top Secret!")
  end
end
```
In the above example, the client will still not run the `if host:isHost() then` block because the
client does not pass the host check even though it is in a ping.
```lua
<HOST>                                    <CLIENT>
├•function pings.coolPing()               ├•function pings.coolPing()
├•  print("Hello World!")                 ├•  print("Hello World!")
├•  models.MyModel.Head:setVisible(false) ├•  models.MyModel.Head:setVisible(false)
├•  myCoolFunction()                      ├•  myCoolFunction()
│                                         │
├•  if host:isHost() then                 │   if host:isHost() then
├•    print("Top Secret!")                │     print("Top Secret!")
├•  end                                   │   end
└•end                                     └•end
```


```lua
table
```


---

# pings.goofyChat


```lua
function pings.goofyChat(message: any)
```


---

# pings.patpat

 pings


```lua
function pings.patpat(a: any, b: any, c: any)
```


---

# pings.syncName


```lua
function pings.syncName(name: any, ...any)
```


---

# player

The Minecraft player the current avatar is attached to.
<!--


```lua
Player
```


---

# print

Receives any number of arguments and prints them to chat seperated by two spaces.  
If a string value is given, it will be printed as-is with no formatting.

If a non-string value is given, the value will be formatted in a readable manner and given a
special color depending on the type.
* `nil`: Red,
* `boolean`: Purple,
* `number`: Cyan,
* `function`: Green,
* `table`: Blue,
* `userdata`: Yellow.

~~[View documents](command:extension.lua.doc?["en-us/52/manual.html/pdf-print"])~~  
This function has been modified by Figura and does not work how it does in normal Lua 5.2.


```lua
function print(...any)
  -> string
```


---

# printJson

Receives any number of arguments and prints them to chat without a seperator.  
If a string value is given, it will be parsed as a Raw JSON Text component.

This function does not print the standard log prefix.


```lua
function printJson(...any)
  -> string
```


---

# printTable

Prints the contents of the given table or userdata object to chat down to the specified depth.  
If a userdata object is given, every default Figura method and field on it is printed.

If a non-table value is given, it is printed similar to `print`. (Except for strings, which get
double quotes around them.)

If `depth` is `nil`, it will default to `1`.  
If `silent` is `nil`, it will default to `false`.


```lua
function printTable(t: any, depth?: integer, silent?: boolean)
  -> string
```


---

# rawequal

Checks whether v1 is equal to v2, without invoking the `__eq` metamethod.

[View documents](command:extension.lua.doc?["en-us/52/manual.html/pdf-rawequal"])


```lua
function rawequal(v1: any, v2: any)
  -> boolean
```


---

# rawget

Gets the real value of `table[index]`, without invoking the `__index` metamethod.

[View documents](command:extension.lua.doc?["en-us/52/manual.html/pdf-rawget"])


```lua
function rawget(table: table, index: any)
  -> any
```


---

# rawlen

Returns the length of the object `v`, without invoking the `__len` metamethod.

[View documents](command:extension.lua.doc?["en-us/52/manual.html/pdf-rawlen"])


```lua
function rawlen(v: string|table)
  -> len: integer
```


---

# rawset

Sets the real value of `table[index]` to `value`, without using the `__newindex` metamethod.
`table` must be a table, `index` any value different from `nil` and `NaN`, and `value` any Lua
value.  
This function returns `table`.

[View documents](command:extension.lua.doc?["en-us/52/manual.html/pdf-rawset"])


```lua
function rawset(table: table, index: any, value: any)
  -> table
```


---

# raycast


```lua
RaycastAPI
```


---

# renderer

An API related to rendering and the camera.


```lua
RendererAPI
```


---

# renderlayers

`renderlayers` is deprecated. It has no replacements.


```lua
nil
```


---

# require

Loads the given module, returns any value returned by the given module (`true` when `nil`).

~~[View documents](command:extension.lua.doc?["en-us/52/manual.html/pdf-require"])~~  
This function has been modified by Figura and does not work how it does in normal Lua 5.2.


```lua
function require(modname: string)
  -> ...unknown
```


```lua
function require(modname: <module:string>, backup: fun(modname: <module:string>):unknown)
  -> ...unknown
```


---

# select

If `index` is a number, returns all arguments after argument number `index`; a negative number
indexes from the end (`-1` is the last argument). Otherwise, `index` must be the string `"#"`,
and `select` returns the total number of extra arguments it received.

[View documents](command:extension.lua.doc?["en-us/52/manual.html/pdf-select"])


```lua
function select(index: integer, ...any)
  -> ...any
```


```lua
function select(index: "#", ...any)
  -> integer
```


---

# setmetatable

Sets the metatable for the given table. If `metatable` is `nil`, removes the metatable of the
given table. If the original metatable has a `__metatable` field, raises an error.

This function returns `table`.

[View documents](command:extension.lua.doc?["en-us/52/manual.html/pdf-setmetatable"])


```lua
function setmetatable(table: table, metatable?: table)
  -> table
```


---

# sound

`sound` is deprecated. Replace the following:
* `sound.getRegisteredCustomSounds()` with `sounds:getCustomSounds()`
* `sound.isCustomSoundRegistered()` with `sounds:isPresent()`
* `sound.playCustomSound()` with `sounds:playSound()`
* `sound.playSound()` with `sounds:playSound()`
* `sound.registerCustomSound()` with `sounds:newSound()`
* `sound.stopCustomSound()` with `sounds:stopSound()`

The following do not have a replacement:
* `sound.getCustomSounds()`

`sound.getSounds()` does not have a direct counterpart, however its functionality can be emulated with the
`ON_PLAY_SOUND` event.


```lua
nil
```


---

# sounds

An API for playing and adding sounds.

Indexing this API with a string that does not result in a method will return a `Sound` object.
This object can then be run with `<Sound>:play()`.


```lua
SoundAPI
```


---

# spyglass_model

`spyglass_model` is deprecated. It has no replacement.


```lua
nil
```


---

# storeValue

`storeValue()` is deprecated. To store a value on the avatar, use `avatar:store()`.


```lua
nil
```


---

# string




[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string"])



```lua
stringlib
```


---

# string.byte


Returns the internal numeric codes of the characters `s[i], s[i+1], ..., s[j]`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.byte"])


```lua
function string.byte(s: string|number, i?: integer, j?: integer)
  -> ...integer
```


---

# string.char


Returns a string with length equal to the number of arguments, in which each character has the internal numeric code equal to its corresponding argument.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.char"])


```lua
function string.char(byte: integer, ...integer)
  -> string
```


---

# string.dump


Returns a string containing a binary representation (a *binary chunk*) of the given function.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.dump"])


```lua
function string.dump(f: fun(...any):...unknown)
  -> string
```


---

# string.find


Looks for the first match of `pattern` (see [§6.4.1](command:extension.lua.doc?["en-us/52/manual.html/6.4.1"])) in the string.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.find"])

@*return* `start`

@*return* `end`

@*return* `...` — captured


```lua
function string.find(s: string|number, pattern: string|number, init?: integer, plain?: boolean)
  -> start: integer|nil
  2. end: integer|nil
  3. ...any
```


---

# string.format


Returns a formatted version of its variable number of arguments following the description given in its first argument.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.format"])


```lua
function string.format(s: string|number, ...any)
  -> string
```


---

# string.gmatch


Returns an iterator function that, each time it is called, returns the next captures from `pattern` (see [§6.4.1](command:extension.lua.doc?["en-us/52/manual.html/6.4.1"])) over the string s.

As an example, the following loop will iterate over all the words from string s, printing one per line:
```lua
    s =
"hello world from Lua"
    for w in string.gmatch(s, "%a+") do
        print(w)
    end
```


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.gmatch"])


```lua
function string.gmatch(s: string|number, pattern: string|number)
  -> fun():string, ...unknown
```


---

# string.gsub


Returns a copy of s in which all (or the first `n`, if given) occurrences of the `pattern` (see [§6.4.1](command:extension.lua.doc?["en-us/52/manual.html/6.4.1"])) have been replaced by a replacement string specified by `repl`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.gsub"])


```lua
function string.gsub(s: string|number, pattern: string|number, repl: string|number|function|table, n?: integer)
  -> string
  2. count: integer
```


---

# string.len


Returns its length.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.len"])


```lua
function string.len(s: string|number)
  -> integer
```


---

# string.lower


Returns a copy of this string with all uppercase letters changed to lowercase.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.lower"])


```lua
function string.lower(s: string|number)
  -> string
```


---

# string.match


Looks for the first match of `pattern` (see [§6.4.1](command:extension.lua.doc?["en-us/52/manual.html/6.4.1"])) in the string.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.match"])


```lua
function string.match(s: string|number, pattern: string|number, init?: integer)
  -> ...any
```


---

# string.pack


Returns a binary string containing the values `v1`, `v2`, etc. packed (that is, serialized in binary form) according to the format string `fmt` (see [§6.4.2](command:extension.lua.doc?["en-us/52/manual.html/6.4.2"])) .

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.pack"])


```lua
function string.pack(fmt: string, v1: string|number, v2?: string|number, ...string|number)
  -> binary: string
```


---

# string.packsize


Returns the size of a string resulting from `string.pack` with the given format string `fmt` (see [§6.4.2](command:extension.lua.doc?["en-us/52/manual.html/6.4.2"])) .

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.packsize"])


```lua
function string.packsize(fmt: string)
  -> integer
```


---

# string.rep


Returns a string that is the concatenation of `n` copies of the string `s` separated by the string `sep`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.rep"])


```lua
function string.rep(s: string|number, n: integer, sep?: string|number)
  -> string
```


---

# string.reverse


Returns a string that is the string `s` reversed.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.reverse"])


```lua
function string.reverse(s: string|number)
  -> string
```


---

# string.sub


Returns the substring of the string that starts at `i` and continues until `j`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.sub"])


```lua
function string.sub(s: string|number, i: integer, j?: integer)
  -> string
```


---

# string.unpack


Returns the values packed in string according to the format string `fmt` (see [§6.4.2](command:extension.lua.doc?["en-us/52/manual.html/6.4.2"])) .

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.unpack"])


```lua
function string.unpack(fmt: string, s: string, pos?: integer)
  -> ...any
  2. offset: integer
```


---

# string.upper


Returns a copy of this string with all lowercase letters changed to uppercase.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.upper"])


```lua
function string.upper(s: string|number)
  -> string
```


---

# table




[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table"])



```lua
tablelib
```


---

# table.concat


Given a list where all elements are strings or numbers, returns the string `list[i]..sep..list[i+1] ··· sep..list[j]`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.concat"])


```lua
function table.concat(list: table, sep?: string, i?: integer, j?: integer)
  -> string
```


---

# table.foreach


Executes the given f over all elements of table. For each element, f is called with the index and respective value as arguments. If f returns a non-nil value, then the loop is broken, and this value is returned as the final value of foreach.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.foreach"])


```lua
function table.foreach(list: any, callback: fun(key: string, value: any):<T>|nil)
  -> <T>|nil
```


---

# table.foreachi


Executes the given f over the numerical indices of table. For each index, f is called with the index and respective value as arguments. Indices are visited in sequential order, from 1 to n, where n is the size of the table. If f returns a non-nil value, then the loop is broken and this value is returned as the result of foreachi.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.foreachi"])


```lua
function table.foreachi(list: any, callback: fun(key: string, value: any):<T>|nil)
  -> <T>|nil
```


---

# table.getn


Returns the number of elements in the table. This function is equivalent to `#list`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.getn"])


```lua
function table.getn(list: <T>[])
  -> integer
```


---

# table.insert


Inserts element `value` at position `pos` in `list`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.insert"])


```lua
function table.insert(list: table, pos: integer, value: any)
```


---

# table.maxn


Returns the largest positive numerical index of the given table, or zero if the table has no positive numerical indices.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.maxn"])


```lua
function table.maxn(table: table)
  -> integer
```


---

# table.move


Moves elements from table `a1` to table `a2`.
```lua
a2[t],··· =
a1[f],···,a1[e]
return a2
```


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.move"])


```lua
function table.move(a1: table, f: integer, e: integer, t: integer, a2?: table)
  -> a2: table
```


---

# table.pack


Returns a new table with all arguments stored into keys `1`, `2`, etc. and with a field `"n"` with the total number of arguments.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.pack"])


```lua
function table.pack(...any)
  -> table
```


---

# table.remove


Removes from `list` the element at position `pos`, returning the value of the removed element.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.remove"])


```lua
function table.remove(list: table, pos?: integer)
  -> any
```


---

# table.sort


Sorts list elements in a given order, *in-place*, from `list[1]` to `list[#list]`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.sort"])


```lua
function table.sort(list: <T>[], comp?: fun(a: <T>, b: <T>):boolean)
```


---

# table.unpack


Returns the elements from the given list. This function is equivalent to
```lua
    return list[i], list[i+1], ···, list[j]
```
By default, `i` is `1` and `j` is `#list`.


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.unpack"])


```lua
function table.unpack(list: <T>[], i?: integer, j?: integer)
  -> ...<T>
```


---

# textures

An API for handling textures used by the avatar.

Indexing this API with a string that does not result in a method may return a `Texture` object.


```lua
TextureAPI
```


---

# toJson

Converts a Lua value into a JSON string.

Any value that is not a boolean, number, string, or table will become a `null`.


```lua
function toJson(value: any)
  -> string
```


---

# tonumber

When called with no `base`, `tonumber` tries to convert its argument to a number. If the argument
is already a number or a string convertible to a number, then `tonumber` returns this number;
otherwise, it returns `nil`.

When called with `base`, then `e` should be a string to be interpreted as an integer numeral in
that base. The base may be any integer between 2 and 36, inclusive. In bases above 10, the letter
'A' (in either upper or lower case) represents 10, 'B' represents 11, and so forth, with 'Z'
representing 35. If the string `e` is not a valid numeral in the given base, the function returns
`nil`.

The string may have leading and trailing spaces and a sign.

[View documents](command:extension.lua.doc?["en-us/52/manual.html/pdf-tonumber"])


```lua
function tonumber(e: any)
  -> number?
```


---

# tostring

Receives a value of any type and converts it to a string in a human-readable format.

If the metatable of `v` has a `__tostring` field, then `tostring` calls the corresponding value
with `v` as argument, and uses the result of the call as its result.

For complete control of how numbers are converted, use
[string.format](command:extension.lua.doc?["en-us/52/manual.html/pdf-string.format"]).

[View documents](command:extension.lua.doc?["en-us/52/manual.html/pdf-tostring"])


```lua
function tostring(v: any)
  -> string
```


---

# twoLeadTrail

A trail type that is controlled by two world positions

## ID


```lua
integer
```

## __index


```lua
twoLeadTrail
```

A trail type that is controlled by two world positions

## delete


```lua
(method) twoLeadTrail:delete()
```

Deletes all the sprite tasks, must be called when discarding the object.

## diverge


```lua
number
```

## duration


```lua
integer
```

## leadA


```lua
Vector3
```

A vector that is three elements long.

## leadB


```lua
Vector3
```

A vector that is three elements long.

## lead_width


```lua
number
```

## points


```lua
table
```

## rebuildSpriteTasks


```lua
(method) twoLeadTrail:rebuildSpriteTasks()
  -> twoLeadTrail
```

Rebuilds the sprite tasks.

## render_type


```lua
ModelPart.renderType
```

## setDivergeness


```lua
(method) twoLeadTrail:setDivergeness(index: number)
  -> twoLeadTrail
```

sets the divergeness index.  
the index can be a decimal, for control over how much the effect applies.
***
 0 : shrink  
 0.5 : shrink halfway  
 1 : none  
 1.5 : grow halfway  
 2 : grow  

## setDuration


```lua
(method) twoLeadTrail:setDuration(ticks: integer)
  -> twoLeadTrail
```

Sets the duration of the trail, the duration is based on update ticks(not minecraft ticks).

## setLeads


```lua
(method) twoLeadTrail:setLeads(A: Vector3, B: Vector3, scale: number|nil)
  -> twoLeadTrail
```

Sets the two points which the trail will follow  
3rd agument defaults to 1 if none given

## setRenderType


```lua
(method) twoLeadTrail:setRenderType(render_type: ModelPart.renderType)
  -> twoLeadTrail
```

Sets the render type of the smear.

```lua
render_type:
    | "NONE" -- Disable rendering.
    | "CUTOUT" -- Default render mode. Used for simple opaque and transparent parts.
    | "CUTOUT_CULL" -- Similar to `"CUTOUT"`, but inside faces do not render.
    | "TRANSLUCENT" -- Used to allow translucency.
    | "TRANSLUCENT_CULL" -- Similar to `"TRANSLUCENT"`, but inside faces do not render.
    | "EMISSIVE" -- Default secondary render mode. Used for emissive textures.
    | "EMISSIVE_SOLID" -- Similar to `"EMISSIVE"`, but color is not additive.
    | "END_PORTAL" -- Applies the end portal field effect.
    | "END_GATEWAY" -- Similar to `"END_PORTAL"`, but contains another layer of blue "particles".
    | "GLINT" -- Applies the enchantment glint effect.
    | "GLINT2" -- Similar to `"GLINT"`, but with only one denser glint layer.
    | "LINES" -- Adds a white outline.
    | "LINES_STRIP" -- Similar to `"LINES"`, but also adds some more lines in-between.
```

## sprites


```lua
table
```

## sprites_flipped


```lua
table
```

## texture


```lua
Texture
```

A texture for use by the avatar.

## update


```lua
(method) twoLeadTrail:update()
  -> twoLeadTrail
```

Updates the Trail Rendering


---

# type

Returns the type of its only argument, coded as a string.  
If the metatable of `v` has a `__type` index, this function will return that instead.

~~[View documents](command:extension.lua.doc?["en-us/52/manual.html/pdf-type"])~~  
This function has been modified by Figura and does not work how it does in normal Lua 5.2.

```lua
-- A valid type given by the `type` function.
type:
    | "nil"
    | "number"
    | "string"
    | "boolean"
    | "table"
    | "function"
    | "Action"
    | "ActionWheelAPI"
    | "Animation"
    | "AnimationAPI"
    | "AvatarAPI"
    | "Biome"
    | "BlockState"
    | "BlockTask"
    | "ClientAPI"
    | "ConfigAPI"
    | "EntityAPI"
    | "EntityNameplateCustomization"
    | "Event"
    | "EventsAPI"
    | "HostAPI"
    | "ItemStack"
    | "ItemTask"
    | "Keybind"
    | "KeybindAPI"
    | "LivingEntityAPI"
    | "MatricesAPI"
    | "Matrix2"
    | "Matrix3"
    | "Matrix4"
    | "ModelPart"
    | "NameplateAPI"
    | "NameplateCustomization"
    | "NameplateCustomizationGroup"
    | "NullEntity"
    | "Page"
    | "Particle"
    | "ParticleAPI"
    | "PingAPI"
    | "PingFunction"
    | "PlayerAPI"
    | "RenderTask"
    | "RendererAPI"
    | "Sound"
    | "SoundAPI"
    | "SpriteTask"
    | "TextTask"
    | "Texture"
    | "TextureAPI"
    | "TextureAtlas"
    | "VanillaModelAPI"
    | "VanillaModelGroup"
    | "VanillaModelPart"
    | "VanillaPart"
    | "Vector2"
    | "Vector3"
    | "Vector4"
    | "VectorsAPI"
    | "Vertex"
    | "ViewerAPI"
    | "WorldAPI"
```


```lua
function type(v: any)
  -> type: type
```


---

# user

The Minecraft entity the current avatar is attached to.
<!--


```lua
Entity
```


---

# vanilla_model

An API for handling the vanilla player model.


```lua
VanillaModelAPI
```


---

# vec

Alias of `<VectorsAPI>.vec`.
> ***
> Creates a vector out of the given numbers.
> ***


```lua
function vec(x: number, y: number)
  -> Vector2
```


```lua
function vec(x: number, y: number, z: number)
  -> Vector3
```


```lua
function vec(x: number, y: number, z: number, w: number)
  -> Vector4
```


---

# vectors

An API for handling and creating vectors.


```lua
VectorAPI
```


---

# world

An API for getting information from the current Minecraft world.


```lua
WorldAPI
```


---

# xpcall

Calls function `f` with the given arguments in protected mode with a new message handler.

[View documents](command:extension.lua.doc?["en-us/52/manual.html/pdf-xpcall"])


```lua
function xpcall(f: function, msgh: function, ...any)
  -> success: boolean
  2. result: any
  3. ...any
```