Shader "Phunky/Stencil/Stencil-Mask"
{
	Properties{
		[Enum(Off, 0, Front, 1, Back, 2)] _CullMode("Cull", Int) = 0
		[Enum(Off, 0, On, 1)] _ZWriteMode("ZWrite", Int) = 1
		[Enum(Always, 0, Less, 1, LEqual, 2, Equal, 3, GEqual, 4, Greater, 5)] _ZTestMode("ZTest", Int) = 2
	}
	SubShader{		
		
		Tags { "RenderType"="Opaque" "Queue"="Geometry-100"}
		
		Cull [_CullMode]
		ZWrite [_ZWriteMode]
		ZTest [_ZTestMode]

		ColorMask 0
		Stencil{
			Ref 1
			Comp always
			Pass replace
		}

		Pass
		{
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				return o;
			}

			half4 frag(v2f i) : COLOR
			{
				return half4(1,1,0,1);
			}
		ENDCG
		}
	}
}


/*
	Pass {
			Cull Front
			ZTest Less

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			ENDCG
		}

		Pass {
			Cull Back
			ZTest Greater

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			ENDCG
		}

		*/
