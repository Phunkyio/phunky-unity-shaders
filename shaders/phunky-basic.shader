Shader "Phunky/phunky-basic-wip"{
    Properties{
        _MainTex("Main Texture", 2D) = "white"{}
        _Color("Color", color) = (1,1,1,1)
        _BumpMap("Normal Map", 2D) = "bump"{}
    }
    SubShader{
        Tags {"RenderType" = "Opaque"}

        CGPROGRAM
            // #pragma surface surf Lambert
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
      
            Sampler2D _MainTex;
            Sampler2D _BumpMap;

            struct appdata {
                float2 uv_MainTex;
                float2 uv_BumpMap;
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
            }

            // void surf(appdata IN, inout SurfaceOutput o){
            //     o.Abledo = tex2D(_MainTex, IN.uv_MainTex).rbg;
            //     o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            // }
            
            void vert(){
            }

            void frag(){
            }
        ENDCG
    }
    Fallback "Diffuse"
}