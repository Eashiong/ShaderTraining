// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Blur/blur2"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_ZFuzzy ("Fuzzy", Range(0,1)) = 0

	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag			
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float ZWorld : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _ZFuzzy;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex); 
				o.ZWorld = mul(unity_ObjectToWorld,o.vertex).z;
				//o.ZWorld = o.vertex.z; 
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				//使用偏导函数
				float2 dx = ddx(i.ZWorld) * _ZFuzzy;
				float2 dy = ddy(i.ZWorld) * _ZFuzzy;
				fixed4 col = tex2D(_MainTex, i.uv,dx,dy);		
				return col;
			}
			ENDCG
		}
	}
}
