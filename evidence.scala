sealed trait Archetype
sealed trait User extends Archetype
sealed trait System extends Archetype

sealed trait Message[A <: Archetype]

type UserMessage = Message[User]
type SystemMessage = Message[System]

final case class UserLoggedIn(name: String) extends Message[User]
final case class SystemError(e: Throwable) extends Message[System]

trait MessageHandler[A] {
  def handleMessage(x: A): Unit
}

object MessageHandler {
  def apply[A:MessageHandler]: MessageHandler[A] = implicitly
}

implicit object UserHandler extends MessageHandler[UserMessage] {
  def handleMessage(msg: Message[User]): Unit = msg match {
    case UserLoggedIn(name) => println(s"$name logged in...")
  }
}

implicit object SystemHandler extends MessageHandler[SystemMessage] {
  def handleMessage(msg: Message[System]): Unit = msg match {
    case SystemError(e) => println(s"System Error: ${e.getMessage}")
  }
}

object Router {
  def onMessage[A <:Archetype](msg: Message[A])(implicit handler: Message[A] => Unit): Unit = handler(msg)
  implicit def sysMessage(msg: SystemMessage) = MessageHandler[SystemMessage].handleMessage(msg)
  implicit def userMessage(msg: UserMessage) = MessageHandler[UserMessage].handleMessage(msg)
}

import Router._
onMessage(UserLoggedIn("Hoo ha!"))
onMessage(SystemError(new IllegalArgumentException("WTF!!!")))
