Shader ".Phunky/hide-overlay-depth-mask" {
//shader has issues with skybox
	SubShader{
		// draw before transparent render queue:
		Tags{ "Queue" = "Overlay-1" }
		Pass{
		Blend Zero One // keep the image behind it
	}
	}
}
