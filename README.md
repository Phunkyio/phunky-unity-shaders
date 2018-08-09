# phunky-unity-shaders
A collection of shaders that I have created, tested, and used for various Unity projects

## Shader Usage
### blend-op-darken
Use the shader on a primitive and you can tint the area inside/outside of it without using a grabpass. Depth is turned off so it will always appear on screen even if behind another object.

### burning-paper
Converted and modified from shaderslab. Use with a 2d noise texture for the Dissolve Texture slot. The Threshold slider will make the object it is on dissolve in and out of view.

### echolocation
WIP. Converted from shaderslab. I plan to have this work using world uv coordinates.

### fire
WIP. Modified version of Bail's fire shader.

### grab-pass-blur
Place the shader on a primitive and it blurs everything the primitive is on top of. Depth test value is set to always pass by default, so the blur will show even if the object is obstructed.

### grab-pass-grayscale
Converted from the grayscale image effect from the standard unity assets. Reproduces the desaturation of the image effect by using an object and not a camera.

TBC...