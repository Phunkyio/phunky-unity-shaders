Shader "Phunky/invert-post-effect"
{
    Properties
    {
           _MainTex("Main Texture", 2D) = "white" {}
    }
    SubShader {
        //No culling or depth
        Cull Off
        ZWrite Off
        ZTest Always

        Pass {
            CGPROGRAM
            //vertex and fragment shader
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
            //define struct types
            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION
            };
            
            //vertex function
            v2f vert(appdata v){
                v2f o;
                o.vertex= mul(UNITY_MATRIX_MVP, v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            
            //fragment function
            fixed4 frag(v2f i) : SV_Target {
                //if running at 1920x1080.. over 2 million pixels
                //function runs once per pixel
                

                //main texture is screen, Graphics.Blit(src, dest, mat)
                fixed4 col = tex2D(_MainTex,IN.uv)
                //invert colors
                col = 1 - col;

                return col;
            }
        }
    }
}