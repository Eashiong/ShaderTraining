// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Wave/Wave2"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Range("Range",Range(0,1)) = 1
		_Frequency("Frequency",Range(0,1)) = 0.5
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
				
				//旗帜波形
				v.vertex.y += _Range * sin(v.vertex.x * _Frequency + _Time.y);
				
				//圆形波
				//v.vertex.y = _Range * sin( -length(v.vertex.xz) * _Frequency + _Time.y);

				//水波x
				//v.vertex.y = _Range * sin( (v.vertex.x + v.vertex.z) * _Frequency + _Time.w);
				//v.vertex.y = _Range * sin( (v.vertex.x - v.vertex.z) * _Frequency + _Time.w);
				//v.vertex.y = _Range * sin( (v.vertex.z + v.vertex.x) * _Frequency + _Time.w);
				//v.vertex.y = _Range * sin( (v.vertex.z - v.vertex.x) * _Frequency + _Time.w);

				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);				
				return col;
			}
			ENDCG
		}
	}
}
