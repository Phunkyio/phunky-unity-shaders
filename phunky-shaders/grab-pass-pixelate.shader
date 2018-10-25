//This shader replicates the pixelate post processing image effect as a material shader that can be placed on meshes.
Shader "Phunky/grab-pass-pixelate" {
	Properties {
		_PixelSize("Pixel Size", Float) = 10
		[Enum(UnityEngine.Rendering.CullMode)] _CullMode ("Cull Mode", Int) = 1
		[Enum(Off, 0, On, 1)] _ZWriteMode ("ZWrite Mode", Int) = 1
		[Enum(Less, 0, Greater, 1, LEqual, 2, GEqual, 3, Equal, 4, NotEqual, 5, Always, 6)] _ZTestMode ("ZTest Mode", Int) = 2
	}
	SubShader {
		Tags{ "Queue" = "Overlay" "IgnoreProjector" = "True" }
		Blend Off
		Lighting Off
		Fog{ Mode Off }
		Cull [_CullMode]
		ZWrite [_ZWriteMode]
		ZTest [_ZTestMode]

		GrabPass{ "_GrabTexture" }

		Pass {
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f {
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;
			};

			float _PixelSize;

			v2f vert(appdata_base v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = ComputeGrabScreenPos(o.pos);
				return o;
			}

			sampler2D _GrabTexture;

			float4 frag(v2f IN) : COLOR {
				float2 steppedUV = IN.uv.xy / IN.uv.w;
				steppedUV /= _PixelSize / _ScreenParams.xy;
				steppedUV = round(steppedUV);
				steppedUV *= _PixelSize / _ScreenParams.xy;
				return tex2D(_GrabTexture, steppedUV);
			}

			ENDCG
		}
	}
}
