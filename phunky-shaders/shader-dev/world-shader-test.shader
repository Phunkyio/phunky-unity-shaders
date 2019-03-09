
Shader "phunky/world-shader"
{
	Properties
	{

	}
	SubShader
	{
		// No culling or depth
		//Cull On ZWrite On ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float4 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 normal : NORMAL;
				float4 rayEnd : TEXCOORD1;
				float3 rayDirection : TEXCOORD2;
				float4 objectPos : TEXCOORD3;
				float3 worldNormal : TEXCOORD4;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;

				o.rayEnd = mul(v.vertex, unity_ObjectToWorld);
				o.rayDirection = o.rayEnd - _WorldSpaceCameraPos;
				o.normal = v.normal;
				o.worldNormal = UnityObjectToWorldNormal(v.normal);

				o.objectPos = v.vertex;

				return o;
			}
			
			sampler2D _MainTex;

			fixed4 frag (v2f i) : SV_Target
			{
				float rayStart = _WorldSpaceCameraPos;

				float2 offsets = (i.uv - 0.5);

				float4 viewVertex = mul(i.vertex, unity_CameraInvProjection);
				viewVertex.z = 0;



				//  return float4(distance_cylinder(i.rayEnd - i.rayDirection, 0), 1);

				float sunRadius = 200;
				float time = i.objectPos.y * 10 + _Time[0];

				float4 lightpos = float4(sin(time), 0, cos(time), 1);

				float4 samplePos = i.objectPos;
				samplePos.y *= 10;

				float4 relativeLightDirection = normalize(samplePos - lightpos);
				
				float3 pertubedNormal = normalize(i.worldNormal);

				float sunIntensity = dot(relativeLightDirection, i.normal);
				float surfaceAngle = dot(pertubedNormal, -normalize(i.rayDirection));
				//return surfaceAngle;

				float angle = dot(float3(0, 0, -1), normalize(float3(i.objectPos.x, 0, i.objectPos.z))) + 1;
				float textureIntensity = (sin(angle * 97.7 + i.objectPos.y * 300) + 1) / 2 / 4 + 0.75;

				float4 color = sunIntensity * float4(1, 1, 1, 1) + (1 - sunIntensity) * float4(0.55, 0.55, 0.8, 1);
				return surfaceAngle * textureIntensity * color;

				//return float4(i.rayDirection, 1);
			}
			ENDCG
		}
	}
}