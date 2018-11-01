Shader "Phunky/grab-pass-hide-transparent" {
    Properties {
        [Enum(UnityEngine.Rendering.CullMode)] _CullMode("Cull", Int) = 0
        [Enum(Off, 0, On, 1)] _ZWriteMode("ZWrite", Int) = 1
        [Enum(Less, 0, LEqual, 1, Equal, 2, GEqual, 3, Greater, 4, NotEqual, 5, Always, 6)] _ZTestMode("ZTest", Int) = 1
    }
    SubShader {
        // Draw ourselves after all opaque geometry
        Tags { "Queue" = "Transparent-1" }
        Cull [_CullMode]
        ZWrite [_ZWriteMode]
        ZTest [_ZTestMode]
        
        // Grab the screen behind the object into _BackgroundTexture
        GrabPass {
            "_BackgroundTexture"
        }

        // Render the object with the texture generated above, and invert the colors
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f {
                float4 grabPos : TEXCOORD0;
                float4 pos : SV_POSITION;
            };

            v2f vert(appdata_base v) {
                v2f o;
                // use UnityObjectToClipPos from UnityCG.cginc to calculate
                // the clip-space of the vertex
                o.pos = UnityObjectToClipPos(v.vertex);
                // use ComputeGrabScreenPos function from UnityCG.cginc
                // to get the correct texture coordinate
                o.grabPos = ComputeGrabScreenPos(o.pos);
                return o;
            }

            sampler2D _BackgroundTexture;

            half4 frag(v2f i) : SV_Target {
                half4 bgcolor = tex2Dproj(_BackgroundTexture, i.grabPos);
                return bgcolor;
            }
            ENDCG
        }
    }
}
