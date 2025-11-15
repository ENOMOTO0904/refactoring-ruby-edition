# --- ダミークラス（この部分は変更不要です） ---
class Product
  attr_accessor :stock
  def initialize(stock)
    @stock = stock
  end
  def in_stock?(quantity)
    @stock >= quantity
  end
  def reserve!(quantity)
    @stock -= quantity
  end
end

class User
  attr_accessor :credit
  def initialize(credit)
    @credit = credit
  end
end

class Order
  def self.create!(user, product, quantity)
    # 実際にはここでDBに保存される
    puts "[DB] Order created for User ##{user.hash} with #{quantity} of Product ##{product.hash}"
  end
end

class PaymentGateway
  def self.charge(user, amount)
    if user.credit >= amount
      user.credit -= amount
      puts "[Payment] Charged #{amount} yen to User ##{user.hash}"
      true # 成功
    else
      puts "[Payment] FAILED to charge User ##{user.hash}"
      false # 失敗
    end
  end
end

class NotificationService
  def self.send_email(user, message)
    puts "[Email] Sent to User ##{user.hash}: #{message}"
  end
  def self.notify_admin(message)
    puts "[Slack] Notified admin: #{message}"
  end
end


# ▼▼▼ リファクタリング対象のクラス ▼▼▼
# ▼▼▼ リファクタリング後のクラス ▼▼▼
class OrderProcessor
  attr_reader :user, :product, :quantity

  def initialize(user, product, quantity)
    @user = user
    @product = product
    @quantity = quantity
    @error_message = nil # エラーメッセージを保持する
  end

  # ！！責務が分離され、流れが明確になった！！
  def process
    # 各ステップは true/false を返すようにする
    # 失敗したら、即座にエラーを返す
    unless validate_stock
      return { success: false, error: @error_message }
    end

    unless process_payment
      return { success: false, error: @error_message }
    end

    unless process_stock_and_order
      return { success: false, error: @error_message }
    end

    # 通知フェーズ（ここは失敗しても処理を止めない）
    send_notifications

    # --- 5. 成功レスポンス ---
    puts "[Success] Order processed successfully."
    return { success: true, order_id: rand(1000..9999) }
  end

  private

  # --- 1. 検証フェーズ ---
  def validate_stock
    return true if product.in_stock?(quantity)
    
    @error_message = '在庫がありません。'
    puts "[Error] Product out of stock."
    false # 失敗を返す
  end

  # --- 2. 決済フェーズ ---
  def process_payment
    price = 500
    total_amount = price * quantity
    
    payment_success = PaymentGateway.charge(user, total_amount)
    return true if payment_success

    @error_message = '決済に失敗しました。'
    puts "[Error] Payment failed."
    false # 失敗を返す
  end

  # --- 3. 在庫引き当て＆注文作成フェーズ ---
  def process_stock_and_order
    product.reserve!(quantity)
    Order.create!(user, product, quantity)
    puts "[Logic] Stock reserved and order created."
    true # 成功を返す
  rescue => e
    # ※本当は決済のロールバックなどが必要
    @error_message = '注文処理中にエラーが発生しました。'
    puts "[Error] Failed to reserve stock or create order: #{e.message}"
    false # 失敗を返す
  end

  # --- 4. 通知フェーズ ---
  def send_notifications
    NotificationService.send_email(user, "ご注文ありがとうございました。")
    NotificationService.notify_admin("新しい注文が#{quantity}件入りました。")
    puts "[Notification] Sent email and admin notification."
  rescue => e
    # 通知は失敗しても注文自体は成功として扱う
    puts "[Warning] Notification failed, but order is successful: #{e.message}"
    # ここでは false を返さない
  end
end


# --- 実行例（変更不要） ---
user = User.new(10000)
product = Product.new(10)

processor = OrderProcessor.new(user, product, 2)
processor.process