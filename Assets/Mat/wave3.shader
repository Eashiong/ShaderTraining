// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Wave/Wave3"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Amplitude("Amplitude",Range(0,0.1)) = 1
		_Frequency("Frequency",Range(1,10)) = 0.5
		_Range("Range",Range(0,1)) = 1
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

			float _Range;
			float _Frequency;
			float _Amplitude;
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
			
			v2f vert (appdata v)
			{
				v2f o;								

				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float scale = 0;
				float2 uv = i.uv;

				//平静水波
				uv += 0.01 * sin(uv * 3.14 *  _Frequency + _Time.y);


				//模拟投石
				float dis = distance(uv,float2(0.5,0.5));				
				//if(dis<_Range)
				//{
					_Amplitude *= 1 - dis / _Range;
					_Amplitude = saturate(_Amplitude);
					scale = _Amplitude * sin( -dis * 3.14 * _Frequency + _Time.y);
					uv = uv + uv * scale;
				//}
				fixed4 col = tex2D(_MainTex, uv);				
				return col;				
			}
			ENDCG
		}
	}
}
