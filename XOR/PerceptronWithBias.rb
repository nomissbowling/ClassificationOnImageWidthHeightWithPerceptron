class PerceptronWithBias < Perceptron
	# バイアス
	attr_accessor :bias

	# メンバ変数の宣言等
	def initialize(eta, bias = 0)
		# バイアスを設定
		self.bias = bias

		# その他の設定は親のコンストラクタで
		super(eta)
	end

	#-------------------- private methods ---------------------------

	private

	# 入力されたデータ長に応じて出力の配列サイズを変更
	def reinit
		self.output = Array.new(self.input.size, 0)
		self.activated_output = Array.new(self.input.size, 0)
		self.error = 0
	end

	# 各入力データに対するパーセプトロンの出力を計算
	def calc_output
		self.input.size.times do |i|
			self.weight.size.times do |j|
				self.output[i] += self.weight[j] * self.input[i][j]
			end # each
			# バイアスを付与
			self.output[i] += self.bias
		end # each
		self.output
	end

	# 活性化関数(y<0→-1, y>=0→1)
	def activation
		self.activated_output.size.times do |i|
			self.activated_output[i] = self.output[i] >= 0 ? 1 : -1
		end # each
	end

	# 誤差関数
	def calc_error
		self.error = 0
		self.input.size.times do |i|
			# 間違えた場合のみ
			if self.activated_output[i] == self.input_ans[i]
				self.error -= self.output[i] * self.input_ans[i]
			end
		end # each
	end

	# 重みの更新
	def update_weight
		# 更新式 : w_i = w_i + eta * t * x_i (f_w(x_i) ≠ t_i)
		# 更新式 : w_i = w                   (f_w(x_i) = t_i)
		self.input.size.times do |i|
			# 間違っていたら更新式に従って更新
			if self.input_ans[i] != self.activated_output[i]
				self.weight.size.times do |j|
					self.weight[j] += @eta * self.input_ans[i] * self.input[i][j]
				end # each
				# バイアスの更新
				self.bias = self.input_ans[i] - self.output[i]
			end # if
		end # each
	end
end # class
