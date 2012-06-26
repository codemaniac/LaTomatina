package com.codemaniac.latomatina.logic
{
	public class LaTomatinaMedia
	{
		[Embed(source = "assets/splat1.wav", mimeType = "application/octet-stream")]
		public static const SplatSound1:Class;
		
		[Embed(source = "assets/splat2.wav", mimeType = "application/octet-stream")]
		public static const SplatSound2:Class;
		
		[Embed(source = "assets/splat3.wav", mimeType = "application/octet-stream")]
		public static const SplatSound3:Class;
		
		[Embed(source = "assets/splat4.wav", mimeType = "application/octet-stream")]
		public static const SplatSound4:Class;
		
		[Embed(source = "assets/throw.wav", mimeType = "application/octet-stream")]
		public static const ThrowSound:Class;
	}
}