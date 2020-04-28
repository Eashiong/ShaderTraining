// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/SpecularDiffuse"
{
	Properties
	{
		_SpecularColor("_SpecularColor",Color) = (1,1,1,1)
		_Shininess("Shininess",Range(1,60)) = 1
	}
	SubShader
	{
		Tags { "LightMode"="ForwardBase" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma multi_compile_fwdbase
			#pragma vertex vert
			#pragma fragment frag
			
			
			#include "UnityCG.cginc"
			#include  "lighting.cginc"
			
			float4 _SpecularColor;
			float _Shininess;

			struct v2f
			{
				float4 color : color;
				float4 vertex : POSITION;
			};			
			
			v2f vert (appdata_base v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);

				//N法线 L灯光方向
				float3 N = normalize(v.normal);
				float3 L = normalize(_WorldSpaceLightPos0);
				N = mul(float4(N,0),unity_WorldToObject).xyz;
				N = normalize(N);

				//计算简单漫反射 只受平行光影响
				float dif = saturate(dot(N,L));
				o.color = _LightColor0 * dif;

				//计算简单高光
				float3 I = -WorldSpaceLightDir(v.vertex);
				float3 R = reflect(I,N);
				float3 V = WorldSpaceViewDir(v.vertex);
				R = normalize(R);
				V = normalize(V);
				float specularscale = pow( saturate(dot(R,V)) , _Shininess );
				o.color.rgb += _SpecularColor * specularscale;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				
				return i.color + UNITY_LIGHTMODEL_AMBIENT;
			}
			ENDCG
		}
	}
}
