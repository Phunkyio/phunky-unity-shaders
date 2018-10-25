/* This shader replicates the grayscale image effect post processing shader that can be used on the camera in Unity as a material shader. */

Shader "Phunky/grab-pass-grayscale" {
	Properties {
		_ZoomVal("Zoom value", Range(0, 20)) = 0
	}
	SubShader{
		//renderqueue to max to grab everything on screen
		Tags{ "Queue" = "Overlay+1000"
		"RenderType" = "Overlay" }
		GrabPass{ "_GrabTexture" }

		Pass{
			ZTest ALways
			Cull Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f {
				half4 pos : SV_POSITION;
				half4 grabPos : TEXCOORD0;
			};

			sampler2D _GrabTexture;
			half _ZoomVal;

			v2f vert(appdata_base v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.grabPos = ComputeGrabScreenPos(o.pos + half4(0, 0, 0, _ZoomVal));
				return o;
			}

			half4 frag(v2f i) : COLOR{
				fixed4 color = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.grabPos));
				fixed val = (color.x + color.y + color.z) / 3;
				return fixed4(val, val, val, color.a);
			}
		ENDCG
		}
	}
	FallBack "Diffuse"
}
