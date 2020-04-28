// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Blur/blur1"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Fuzzy ("Fuzzy", Range(0,1)) = 0
		_T("time",Range(0,1)) = 0
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
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Fuzzy;
			float _T;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				//使用纹理偏移算法
				/*
				_Fuzzy *= 10;
				float2 uv = i.uv;
				fixed4 col = tex2D(_MainTex, uv);

				uv.x = i.uv.x + _Fuzzy;
				col.rgb += tex2D(_MainTex, uv);

				uv.x = i.uv.x - _Fuzzy;
				col.rgb += tex2D(_MainTex, uv);

				uv.y = i.uv.y + _Fuzzy;
				col.rgb += tex2D(_MainTex, uv);

				uv.y = i.uv.y - _Fuzzy;
				col.rgb += tex2D(_MainTex, uv);

				col.rgb /= 5;
				*/

				//使用偏导函数				
				fixed4 col;
				fixed delx,dely;
				//float t =sin(_Time.y);
				//if(i.uv.x>=_T)
				//{
					delx = i.uv.x * _T;
					dely = i.uv.y * _T;
					float dx = ddx(i.uv.x) * _Fuzzy * 20;
					float dy = ddy(i.uv.y) * _Fuzzy * 20  ;
					col = tex2D(_MainTex, i.uv,float2(dx,dx),float2(dy,dy));
				//}
				//else
				//{
				//	col = col = tex2D(_MainTex, i.uv);
				//}
				return col;
			}
			ENDCG
		}						
		
	}
}
