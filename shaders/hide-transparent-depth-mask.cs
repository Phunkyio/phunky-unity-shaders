Shader "Phunky/hide-transparent-depth-mask" {
	SubShader{
		// draw before transparent render queue:
		Tags{ "Queue" = "Transparent-1" }
		Pass{
		Blend Zero One // keep the image behind it
	}
	}
}