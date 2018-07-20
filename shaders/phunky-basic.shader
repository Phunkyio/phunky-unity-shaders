Shader "Phunky/phunky-basic"{
    Properties{
        _MainTex("Main Texture", 2D) = "white"{}
        _BumpMap("Normal Map", 2D) = "bump"{}
    }
    SubShader{
        Tags {"RenderType" = "Opaque"}

        CGPROGRAM

        #pragma surface surf Lambert
      
        Sampler2D _MainTex;
        Sampler2D _BumpMap;

        struct Input {
            float2 uv_MainTex;
            float2 uv_BumpMap;

            // float4 color : COLOR;
        };


        void surf(Input IN, inout SurfaceOutput o){
            //o.Abledo = 1;

            o.Abledo = tex2D(_MainTex, IN.uv_MainTex).rbg;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
        }
        ENDCG
    }
    Fallback "Diffuse"
}