// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyFriend/MRA_Standard"
{
	Properties
	{
		_ASEOutlineColor( "Outline Color", Color ) = (0,0,0,0)
		_ASEOutlineWidth( "Outline Width", Float ) = 0
		_AlbedoMap("Albedo Map", 2D) = "white" {}
		[NoScaleOffset]_MRAMap("MRA Map", 2D) = "white" {}
		[NoScaleOffset][Normal]_NormalMap("Normal Map", 2D) = "bump" {}
		_Color("Color", Color) = (1,1,1,1)
		_AOColor("AO Color", Color) = (1,1,1,1)
		_Rough("Roughness", Range( 0 , 4)) = 1
		_BumpScale("Normal Intensity", Range( 0 , 2)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ }
		Cull Front
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline nofog  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc 
		
		
		
		
		struct Input {
			half filler;
		};
		float4 _ASEOutlineColor;
		float _ASEOutlineWidth;
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			v.vertex.xyz += ( v.normal * _ASEOutlineWidth );
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			o.Emission = _ASEOutlineColor.rgb;
			o.Alpha = 1;
		}
		ENDCG
		

		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _NormalMap;
		uniform sampler2D _AlbedoMap;
		uniform float4 _AlbedoMap_ST;
		uniform float _BumpScale;
		uniform float4 _AOColor;
		uniform float4 _Color;
		uniform sampler2D _MRAMap;
		uniform float _Rough;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_AlbedoMap = i.uv_texcoord * _AlbedoMap_ST.xy + _AlbedoMap_ST.zw;
			o.Normal = UnpackScaleNormal( tex2D( _NormalMap, uv_AlbedoMap ), _BumpScale );
			float4 blendOpSrc30 = _AOColor;
			float4 blendOpDest30 = ( _Color * tex2D( _AlbedoMap, uv_AlbedoMap ) );
			float4 tex2DNode2 = tex2D( _MRAMap, uv_AlbedoMap );
			float4 lerpBlendMode30 = lerp(blendOpDest30,( blendOpSrc30 * blendOpDest30 ),( 1.0 - tex2DNode2.b ));
			o.Albedo = ( saturate( lerpBlendMode30 )).rgb;
			o.Metallic = tex2DNode2.r;
			o.Smoothness = ( 1.0 - ( _Rough * tex2DNode2.g ) );
			o.Occlusion = tex2DNode2.b;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
24;127;1750;749;2623.354;963.0465;2.384642;True;True
Node;AmplifyShaderEditor.CommentaryNode;32;-1344.636,-515.8077;Inherit;False;485.5201;232.0919;Viens teinter l'albedo si on met une couleur;2;19;15;Albedo Tint;0.3679245,0.3679245,0.3679245,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1915.909,19.99162;Inherit;False;0;12;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;13;-1899.186,-545.232;Float;True;Property;_MRAMap;MRA Map;1;1;[NoScaleOffset];Create;True;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;12;-1913.661,-773.6334;Float;True;Property;_AlbedoMap;Albedo Map;0;0;Create;True;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;2;-1359.024,-10.70754;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-823.289,-48.26651;Float;False;Property;_Rough;Roughness;5;0;Create;False;0;0;False;0;False;1;2;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;14;-1897.81,-293.8597;Float;True;Property;_NormalMap;Normal Map;2;2;[NoScaleOffset];[Normal];Create;True;0;0;False;0;False;None;None;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ColorNode;15;-1294.636,-465.8078;Float;False;Property;_Color;Color;3;0;Create;True;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;33;-792.6831,-673.5778;Inherit;False;544.5194;422.8966;Viens teinter l'AO si on met une couleur dedans;3;28;16;30;AO Tint;0.254717,0.254717,0.254717,1;0;0
Node;AmplifyShaderEditor.SamplerNode;1;-1361.725,-230.8971;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-1364.427,195.9738;Inherit;True;Property;_TextureSample2;Texture Sample 2;0;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-1240.266,518.8428;Float;False;Property;_BumpScale;Normal Intensity;6;0;Create;False;0;0;False;0;False;1;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-1016.685,-461.1527;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;16;-742.6831,-623.5778;Float;False;Property;_AOColor;AO Color;4;0;Create;True;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;28;-709.5595,-339.5271;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-540.9005,7.809017;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;30;-465.9482,-493.9808;Inherit;False;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;31;-354.0712,9.437443;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;22;-810.1135,352.5009;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;427.9522,283.6801;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;MyFriend/MRA_Standard;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;True;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;13;0
WireConnection;2;1;6;0
WireConnection;1;0;12;0
WireConnection;1;1;6;0
WireConnection;3;0;14;0
WireConnection;3;1;6;0
WireConnection;19;0;15;0
WireConnection;19;1;1;0
WireConnection;28;0;2;3
WireConnection;27;0;17;0
WireConnection;27;1;2;2
WireConnection;30;0;16;0
WireConnection;30;1;19;0
WireConnection;30;2;28;0
WireConnection;31;0;27;0
WireConnection;22;0;3;0
WireConnection;22;1;18;0
WireConnection;0;0;30;0
WireConnection;0;1;22;0
WireConnection;0;3;2;1
WireConnection;0;4;31;0
WireConnection;0;5;2;3
ASEEND*/
//CHKSM=E3522D05A983346BE05ED16C0795E6D25DB61E9B