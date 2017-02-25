

trait Appliance {
  def receive(message: Message): Unit
}

type Channel = Int

sealed trait Message
case class PowerEvent() extends Message
case class SelectChannel(c: Channel) extends Message

trait Button {
  def message: Message
  def press(implicit appliance: Appliance): Unit = appliance.receive(message)
}

object Button {
  def apply(msg: Message): Button = {
    new Button {
      def message: Message = msg
    }
  }
}

class TV(val model: String) extends Appliance {
  var on: Boolean = false
  var channel: Channel = 0
  def receive(message: Message): Unit = message match {
    case PowerEvent() => on = !on
    case SelectChannel(ch) => if (on) {
      channel = ch
    }
  }
}

case class Battery(rating: Int)

class TVRemote(tv: TV) {
  import scala.language.postfixOps
  implicit val appliance: Appliance = tv

  private var amperes: Int = 100
  
  val on: Button = Button(PowerEvent())
  val channels: List[Button] = (0 to 10).map(i => Button(SelectChannel(i))).toList

  def togglePower: Unit = press(on)
  def selectChannel(which: Channel): Unit = press(channels(which))
  
  private def press(button: Button): Unit = {
    drain
    if (powerLevel > 20) {
      button press
    }
  }

  def powerLevel: Int = amperes
  private def drain: Unit = if (amperes > 0) amperes -= 1
  def recharge(battery: Battery): Int = {
    amperes = scala.math.max(amperes + battery.rating, 100)
    amperes
  }
  
}

