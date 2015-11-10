# Stitcher

## 目的

* メソッドの多重定義をする
 * 引数によって呼び出すメソッドを切り替える
* メソッドの引数に対しての制限を設ける
 * 引数に対する型チェック
 * 引数に対するコンセプトチェック
* モンキーパッチで定義するメソッドを制限したい
 * 引数が○○○の場合でのみモンキーパッチのメソッドを呼び出す等


## 動作イメージ

```ruby
class X
	include Stitcher

	def plus a, b
		p "plus(a.to_i, b.to_i)"
		a.to_i + b.to_i
	end
	# #plus を呼び出すコンセプトを設定する
	# 引数がそれぞれ #to_i を呼び出せればこのメソッドを呼び出す
	concept :plus do |a, b|
		a.respond_to?(:to_i) && b.respond_to?(:to_i)
	end

	# concept 設定後に別のメソッドを定義し直す事ができる
	def plus a, b
		p "plus(a + b)"
		a + b
	end

	# 再定義したメソッドに対しても条件を設定できる
	# こっちは両方共 Numeric だった場合に呼び出す
	concept :plus do |a, b|
		a.class <= Numeric && b.class <= Numeric
	end
end

X.new.plus "1", "2"
# => 最初に定義したメソッドが呼ばれる
X.new.plus 1, 2
# => あとで定義したメソッドが呼ばれる

X.new.plus X, X
# => どれにも該当しないのでエラー
```


## 考えること

* 呼び出すことができるメソッドが複数あった場合どうするか
* 呼び出すメソッドの優先順位

