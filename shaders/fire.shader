Shader "Phunky/Fire" {
	Properties {
		_ColorA("Main Color A", Color) = (1,1,1) //gradient colors
		_ColorB("Main Color B", Color) = (1,1,1)
		_TintA("Edge Color A", Color) = (1,1,1)
		_TintB("Edge Color B", Color) = (1,1,1)
		_ScrollX(" Scroll Noise X", Range(-10,10)) = 1 // noise animation
		_ScrollY(" Scroll Noise Y", Range(-10,10)) = 1
		_NoiseTex("Noise Texture", 2D) = "white" {}
		_DistortTex(" UVDistort Texture", 2D) = "white" {}
		_Offset("Offset Gradient A/B", Range(-2,2)) = 1
		_Hard("Hard Cutoff", Range(1,40)) = 30
		_Height("Height", Range(-4,10)) = 1
		_Edge("Edge", Range(0,2)) = 1
		_Distort("Distort", Range(0,1)) = 0.2
		[MaterialToggle] SHAPE("Use Mask Texture", Float) = 0
		[MaterialToggle] SHAPEX("Mulitply Noise", Float) = 0
		_ShapeTex("Mask", 2D) = "white" {}
	}
	SubShader {
		Tags{ "RenderType" = "Transparent" "Queue" = "Transparent" }
		LOD 100
		Zwrite Off
		Blend One One // additive blending

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile _ SHAPE_ON
			#pragma multi_compile _ SHAPEX_ON
			// make fog work
			#pragma multi_compile_fog

			#include "UnityCG.cginc"

			struct appdata {
		        float4 vertex : POSITION;
		        float2 uv : TEXCOORD0;
			};

	    struct v2f {
	        float2 uv : TEXCOORD1;
	        float2 uv2 : TEXCOORD2;
	        float2 uv3 : TEXCOORD4;
	        UNITY_FOG_COORDS(3)
	        float4 vertex : SV_POSITION;
	    };

	    sampler2D  _NoiseTex, _ShapeTex, _DistortTex;
	    float4 _DistortTex_ST, _ShapeTex_ST, _NoiseTex_ST;
	    float4 _ColorA, _ColorB, _TintA, _TintB;
	    float _Offset,   _ScrollX, _ScrollY;
	    float _Height, _Edge, _Distort, _Hard;

			v2f vert(appdata v) {
	        v2f o;
	        o.vertex = UnityObjectToClipPos(v.vertex);
	        o.uv = TRANSFORM_TEX(v.uv, _NoiseTex); // -enable scaling and offset
	        o.uv2 = TRANSFORM_TEX(v.uv, _ShapeTex); // for the textures
	        o.uv3 = TRANSFORM_TEX(v.uv, _DistortTex); // we are using-
	        UNITY_TRANSFER_FOG(o,o.vertex);
	        return o;
	    }

    fixed4 frag(v2f i) : SV_Target {
        float4 gradientMain = lerp(_ColorB, _ColorA, (i.uv3.y + _Offset)); // gradient for color
        float4 gradientTint = lerp(_TintB, _TintA, (i.uv3.y + _Offset)); // gradient for color
        float4 gradientBlend = lerp(float4(2,2,2,2), float4(0, 0, 0, 0), (i.uv3.y + _Height)); // gradient to fade to top
        fixed4 uvdistort = tex2D(_DistortTex, i.uv3) * _Distort; // distort texture times distort amount
        fixed4 noise = tex2D(_NoiseTex,fixed2((i.uv.x + _Time.x* _ScrollX) + uvdistort.g  ,(i.uv.y + _Time.x* _ScrollY) + uvdistort.r)); //noise texture with distortion
        fixed4 shapetex = tex2D(_ShapeTex, i.uv2); // mask texture


				#ifdef SHAPE_ON
        noise = 1 - (noise * _Height + (1 - (shapetex * _Hard)));// use the shape mask
				#else
        noise += gradientBlend;// fade the flame at the top
				#endif
				#ifdef SHAPEX_ON
        noise += gradientBlend;// fade the flame at the top over mask
				#endif
        float4 flame = saturate(noise.a * _Hard); //noise flame
        float4 flamecolored =flame *gradientMain; // coloured noise flame
        float4 flamerim = saturate((noise.a + _Edge) * _Hard) - flame; // noise flame edge

        float4 flamecolored2 = flamerim * gradientTint; // coloured flame edge
        float4 finalcolor = flamecolored + flamecolored2; // combined edge and flames
        return finalcolor;


    	}
      ENDCG
  	}
  }
}
