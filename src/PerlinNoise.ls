package
{
	public class PerlinNoise
	{
		private var width:Number;
		private var height:Number;

		public function PerlinNoise(w:Number, h:Number)
		{
			width = w;
			height = h;
		}

		/// Gets the value for a specific X and Y coordinate
		/// results in range [-1, 1] * maxHeight
		public function GetRandomHeight(X:Number, Y:Number, MaxHeight:Number, Frequency:Number,
										Amplitude:Number, Persistance:Number, Octaves:Number):Number
		{
			GenerateNoise();
			var FinalValue = 0;
			for (var i = 0; i < Octaves; ++i)
			{
				FinalValue += GetSmoothNoise(X * Frequency, Y * Frequency) * Amplitude;
				Frequency *= 2;
				Amplitude *= Persistance;
			}
			if (FinalValue < -1)
			{
				FinalValue = -1;
			}
			else if (FinalValue > 1)
			{
				FinalValue = 1;
			}
			return FinalValue * MaxHeight;
		}

		//This function is a simple bilinear filtering function which is good (and easy) enough.
		private function GetSmoothNoise(X:Number, Y:Number):Number
		{
			var FractionX = X - Math.floor(X);
			var FractionY = Y - Math.floor(Y);
			var X1 = (Math.floor(X) + width) % width;
			var Y1 = (Math.floor(Y) + height) % height;
			//for cool art deco looking images, do +1 for X2 and Y2 instead of -1...
			var X2 = (Math.floor(X) + width - 1) % width;
			var Y2 = (Math.floor(Y) + height - 1) % height;
			var FinalValue = 0;
			FinalValue += FractionX * FractionY * Noise[X1][Y1];
			FinalValue += FractionX * (1 - FractionY) * Noise[X1][Y2];
			FinalValue += (1 - FractionX) * FractionY * Noise[X2][Y1];
			FinalValue += (1 - FractionX) * (1 - FractionY) * Noise[X2][Y2];
			return FinalValue;
		}

		var Noise:Vector.<Vector.<Number>>;
		var NoiseInitialized = false;
		private function GenerateNoise()
		{
			if (NoiseInitialized)                //A boolean variable in the class to make sure we only do this once
				return;
			Noise = new Vector.<Vector.<Number>>(width);    //Create the noise table where MAX_WIDTH and MAX_HEIGHT are set to some value>0
			for (var x = 0; x < width; ++x)
			{
				Noise[x] = new Vector.<Number>(height);
				for (var y = 0; y < height; ++y)
				{
					Noise[x][y] = ((float)(Math.randomRange(0, 1)) - 0) * 2;  //Generate noise between -1 and 1
				}
			}
			NoiseInitialized = true;
		}
	}
}