require "active_support"
require "active_support/core_ext"
require_relative "../IsPortrait/Perceptron"

class PerceptronWithBias < Perceptron
	# バイアス
	attr_accessor :bias

	# メンバ変数の宣言等
	def initialize(eta, bias = 0, weights = "114514")
		# バイアスを設定
		self.bias = bias

		# その他の設定は親のコンストラクタで
		super(eta)

		# 重みは自分で更新したい
		if weights == "114514"
			self.weight = [rand(0.0..1.0),rand(0.0..1.0)]
			self.pre_weight = self.weight.deep_dup
		end
	end

	#-------------------- private methods ---------------------------

	private

	# 各入力データに対するパーセプトロンの出力を計算
	def calc_output
		self.input.size.times do |i|
			self.weight.size.times do |j|
				self.output[i] += self.weight[j] * self.input[i][j]
			end # each
			# バイアスを付与
			self.output[i] += self.bias

			puts "bias:#{self.bias}, input[i]:#{self.input[i]}, weight:#{self.weight}, output[#{i}} : #{self.output}"
		end # each
		self.output
	end

	# 重みの更新
	def update_weight
		# 更新式 : w_i = w_i + eta * t * x_i (f_w(x_i) ≠ t_i)
		# 更新式 : w_i = w                   (f_w(x_i) = t_i)
		self.input.size.times do |i|
			# 間違っていたら更新式に従って更新
			if self.input_ans[i] != self.activated_output[i]
				self.weight.size.times do |j|
					self.weight[j] += self.eta * self.input_ans[i] * self.input[i][j]
					 #self.weight[j] += self.eta * (self.input_ans[i] - self.output[i]) * self.input[i][j]
				end # each
				# バイアスの更新
				self.bias += self.eta * (self.input_ans[i] - self.output[i])
				#self.bias -= self.eta * self.input_ans[i]
			end # if
		end # each
	end
end # class
