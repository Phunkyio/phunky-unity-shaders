Shader "Phunky/Stencil/Configurable Stencil Mask"
{
	Properties{
		_Ref("Ref Value", Int) = 0
		[Enum(Always, 0, Less, 1, LEqual, 2, Equal, 3, GEqual, 4, Greater, 5, NotEqual, 6, Never, 7)] _CompFunction("Comparison Function", Int) = 0
		[Enum(Keep, 0, Zero, 1, Replace, 2, IncrSat, 3, DecrSat, 4, Invert, 5, IncrWrap, 6, DecrWrap, 7)] _PassOp("Pass Operation") = 0
		[Enum(Keep, 0, Zero, 1, Replace, 2, IncrSat, 3, DecrSat, 4, Invert, 5, IncrWrap, 6, DecrWrap, 7)] _FailOp("Fail Operation") = 0
		[Enum(Keep, 0, Zero, 1, Replace, 2, IncrSat, 3, DecrSat, 4, Invert, 5, IncrWrap, 6, DecrWrap, 7)] _ZFailOp("ZFail Operation") = 0
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
