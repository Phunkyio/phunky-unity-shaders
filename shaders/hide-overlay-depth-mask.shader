Shader "Phunky/hide-overlay-depth-mask" {
	SubShader{
		// draw before transparent render queue:
		Tags{ "Queue" = "Overlay-1" }
		Pass{
		Blend Zero One // keep the image behind it
	}
	}
}
