class Perceptron
	# 各入力に対する重み(1次元(2))
	attr_accessor :weight

	# 各入力に対する出力(2次元(n,2))
	attr_accessor :output

	# 各入力に対する活性化後の出力(2次元(n,2))
	attr_accessor :activated_output

	# 入力データ(2次元(n,2))
	attr_accessor :input

	# 教師データ(1次元(n))
	attr_accessor :input_ans

	# 入力に対する誤差(Numeric)
	attr_accessor :error

	# 学習率(学習係数)
	attr_accessor :eta

	# 全て正答したか(終了条件)
	attr_accessor :is_all_corrected

	# メンバ変数の宣言等
	def initialize(eta)
		# 学習率(学習係数)
		self.eta = eta

		# 全て正答フラグを初期化
		self.is_all_corrected = false

		# 各入力に対する重みの初期値を乱数で決定
		self.weight = [rand(0.0..10.0), rand(0.0..10.0)]
	end

	# データを入力し出力を得る
	# 学習する場合は引数にTrueをぶちこむ
	def forward(input, ans, learning = false)
		# 入力データを保持
		self.input = input
		self.input_ans = ans

		# 出力サイズを設定
		reinit

		# 重み付きの計算を行う
		self.output = calc_output

		# ↑の出力に対して活性化関数を実行する
		activation

		# 誤差を計算する
		calc_error

		# 全問正答したか(終了条件)
		self.is_all_corrected = (self.activated_output == self.input_ans)

		# 学習を行う(指定されていた場合)
		if learning
			update_weight
		end

		return self.activated_output, self.is_all_corrected
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
			self.error -= self.output[i] * self.input_ans[i]
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
			end # if
		end # each
	end
end # class
