// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Blur/blur3"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Radius ("Radius", Range(0,20)) = 0
		_TextureSize("Size",float) = 0

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
			float _Radius;
			fixed _TextureSize;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex); 
				
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);				
				return o;
			}


			//模糊用2维高斯函数，求半径范围内UV权重，然后把权重归一到（0，1），直接把半径范围内颜色进行叠加
			fixed Gaussian(fixed x, fixed y,fixed o)
			{
				fixed g = 1 / ( o * o * 2 * 3.1415926);
				g *= exp( -(x*x + y*y) / (2 * o * o) );
				return g;
			}
			fixed4 frag (v2f i) : SV_Target
			{	
				fixed weight = 0;//每个元素的权重
				fixed addWeight = 0;//用来计算权重总和
				fixed4 col_0 = tex2D(_MainTex, i.uv);
				col_0.rgb *= saturate(1-(_Radius/0.001)); //_Radius表现的是像素半径，当模糊像素接近0或者等于0时 直接输出原颜色
					
				int x = 0;	
				int y = 0;					
				for(x = -_Radius;x<_Radius + 1;x++)
				{
					for(y = -_Radius;y<=_Radius+1;y++)
					{
						addWeight += Gaussian(x,y,_Radius/3);
						
					}
				}
				for(x = -_Radius;x<_Radius+1;x++)
				{
					for(y = -_Radius;y<=_Radius;y++)
					{
						weight = Gaussian(x,y,_Radius/3) / addWeight;//把每个权重划分到0到1的区间
						float2 myuv = i.uv + float2(x/_TextureSize,y/_TextureSize);						
						fixed3 col = weight * tex2D(_MainTex, i.uv + float2(x/_TextureSize,y/_TextureSize));//_TextureSize是贴图大小，x/_TextureSize映射到0到1
						col_0.rgb += col.rgb;
												 
					}
				}
				return col_0;
				
			}
			ENDCG
		}
	}
}
