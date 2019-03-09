//What was I doing here?

Shader ".Phunky/Dev/Scan"
{
	Properties
	{
		_Color("Color", Color) = (1, 1, 1, 1)
		_ScanColor("Scan Color", Color) = (1, 1, 1, 1)
		_Threshold("Threshold", Range(0.01, 30)) = 0.1
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent" "IgnoreProjector" = "True" }
		LOD 100
		ZWrite Off
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 projPos : TEXCOORD0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Threshold;


			UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);

			float4 _Color;
			float4 _ScanColor;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.projPos = ComputeScreenPos(o.vertex);
				COMPUTE_EYEDEPTH(o.projPos.z);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float4 finalColor = _Color;
				float sceneZ = LinearEyeDepth(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
				float partZ = i.projPos.z;
				float fade = saturate(_Threshold * (sceneZ - partZ));
				finalColor = lerp(_ScanColor, _Color, fade);
				return finalColor;
			}
			ENDCG
		}
	}
}