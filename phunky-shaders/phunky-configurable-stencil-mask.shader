Shader ".Phunky/Configurable Stencil Mask"
{
	Properties{
		_Ref ("Stencil ID [0;255]", Float) = 0
		//_ReadMask ("ReadMask [0;255]", Int) = 255
		//_WriteMask ("WriteMask [0;255]", Int) = 255
		[Enum(UnityEngine.Rendering.CompareFunction)] _CompFunction ("Stencil Comparison", Int) = 3
		[Enum(UnityEngine.Rendering.StencilOp)] _PassOp ("Stencil Operation", Int) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _FailOp ("Stencil Fail", Int) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _ZFailOp ("Stencil ZFail", Int) = 0
		[Enum(Off, 0, Front, 1, Back, 2)] _CullMode("Cull", Int) = 2
		[Enum(Off, 0, On, 1)] _ZWriteMode("ZWrite", Int) = 1
		[Enum(Always, 0, Less, 1, LEqual, 2, Equal, 3, GEqual, 4, Greater, 5)] _ZTestMode("ZTest", Int) = 2
		[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("BlendSource", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("BlendDestination", Float) = 0
	}
	SubShader{		
		
		Tags { "RenderType"="Opaque" "Queue"="Transparent+1"}
		
		Cull [_CullMode]
		ZWrite [_ZWriteMode]
		ZTest [_ZTestMode]
		Blend [_SrcAlpha] [_DstBlend]

		ColorMask 0
		Stencil{
			Ref [_Ref]
			Comp [_CompFunction]
			Pass [_PassOp]
			Fail [_FailOp]
			ZFail [_ZFailOp]
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
	Fallback "Diffuse"
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
