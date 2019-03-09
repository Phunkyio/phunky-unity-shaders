//this shader is being used to change the environment behind a stencil mask

Shader "Phunky/Cubemap Unlit w Stencil" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Main texture (RGB)", 2D) = "white" {}
        _CrossfadeOverlay ("Crossfade Overlay", Range(0, 2)) = 1
        _Cubemap ("Cubemap", Cube) = "_Skybox" {}

        _StencilRef ("Stencil Ref", Int) = 0
        [Enum(Always, 0, Less, 1, LEqual, 2, Equal, 3, GEqual, 4, Greater, 5)] _StencilComp ("Stencil Comp", Int) = 0
        [Enum(Keep, 0, Replace, 1, IncrSat, 2, DecrSat, 3, Invert, 4)] _StencilPass("Stencil Pass", Int) = 0
        [Enum(Keep, 0, Replace, 1, IncrSat, 2, DecrSat, 3, Invert, 4)] _StencilFail("Stencil Fail", Int) = 0
        [Enum(Keep, 0, Replace, 1, IncrSat, 2, DecrSat, 3, Invert, 4)] _StencilZFail("Stencil ZFail", Int) = 0

        [Enum(Off, 0, Front, 1, Back, 2)] _CullMode("Cull", Int) = 0
        [Enum(Off, 0, On, 1)] _ZWrite ("ZWrite", Int) = 1
        [Enum(Always, 0, Less, 1, LEqual, 2, Equal, 3, GEqual, 4, Greater, 5)] _ZTestMode("ZTest", Int) = 2
    }
    SubShader {
  		Stencil{
    		Ref [_StencilRef]
    		Comp [_StencilComp]
    		Pass [_StencilPass]
    		Fail [_StencilFail]
        ZFail [_StencilZFail]
  	  }
        Tags {
            "RenderType"="Opaque"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Cull [_CullMode]
            ZWrite [_ZWrite]
            ZTest [_ZTestMode]


            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma only_renderers d3d9 d3d11 glcore gles
            #pragma target 3.0
            uniform float4 _Color;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform samplerCUBE _Cubemap;
            uniform float _CrossfadeOverlay;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
////// Lighting:
                float node_9970 = 1.0;
                float3 node_7256 = viewDirection.rgb;
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float3 finalColor = lerp(lerp(((lerp(float3(node_9970,node_9970,node_9970),texCUBE(_Cubemap,float3(node_7256.r,(node_7256.g*(-1.0)),node_7256.b)).rgb,saturate(_CrossfadeOverlay))*lerp(float3(node_9970,node_9970,node_9970),_MainTex_var.rgb,saturate((node_9970+(1.0 - _CrossfadeOverlay)))))*_Color.rgb*1.0),dot(((lerp(float3(node_9970,node_9970,node_9970),texCUBE(_Cubemap,float3(node_7256.r,(node_7256.g*(-1.0)),node_7256.b)).rgb,saturate(_CrossfadeOverlay))*lerp(float3(node_9970,node_9970,node_9970),_MainTex_var.rgb,saturate((node_9970+(1.0 - _CrossfadeOverlay)))))*_Color.rgb*1.0),float3(0.3,0.59,0.11)),(-0.5)),dot(lerp(((lerp(float3(node_9970,node_9970,node_9970),texCUBE(_Cubemap,float3(node_7256.r,(node_7256.g*(-1.0)),node_7256.b)).rgb,saturate(_CrossfadeOverlay))*lerp(float3(node_9970,node_9970,node_9970),_MainTex_var.rgb,saturate((node_9970+(1.0 - _CrossfadeOverlay)))))*_Color.rgb*1.0),dot(((lerp(float3(node_9970,node_9970,node_9970),texCUBE(_Cubemap,float3(node_7256.r,(node_7256.g*(-1.0)),node_7256.b)).rgb,saturate(_CrossfadeOverlay))*lerp(float3(node_9970,node_9970,node_9970),_MainTex_var.rgb,saturate((node_9970+(1.0 - _CrossfadeOverlay)))))*_Color.rgb*1.0),float3(0.3,0.59,0.11)),(-0.5)),float3(0.3,0.59,0.11)),(1.0 - _Color.a));
                return fixed4(finalColor,1);
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            Cull Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma only_renderers d3d9 d3d11 glcore gles
            #pragma target 3.0
            struct VertexInput {
                float4 vertex : POSITION;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
