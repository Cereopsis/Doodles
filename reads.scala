
import play.api.libs.json.{Json,JsValue,Writes,Reads}

trait Response[+A] {
  def code: Int
  def body: A
  def error: Option[String] = None
}

case class OK[+A](body: A) extends Response[A] {
  val code = 200
}

object Response {
  import play.api.libs.json.Json.JsValueWrapper
  def responseWriter[A](f: A => JsValueWrapper): Writes[Response[A]] = new Writes[Response[A]]{
    override def writes(o: Response[A]): JsValue = Json.obj(
      "code" -> o.code,
      "body" -> f(o.body),
      "error" -> o.error
    )
  }
}

case object InternalServerError extends Response[Any] {
  val code = 500
  val body = None
  override val error = Some("Internal Server Error")
}


case class Movie(title: String, year: Int, duration: Int)
case class Director(name: String, movies: List[Movie])

object CinemaImplicits {
  implicit val movieWrites = Json.writes[Movie]
  implicit val movieReads  = Json.reads[Movie]
  implicit val directorWrites = Json.writes[Director]
  implicit val directorReads  = Json.reads[Director]
}

val war = Movie("Apocolypse Now", 1979, 153)
val comedies = List(Movie("Some Like it Hot", 1959, 120), Movie("Sabrina", 1954, 113))
val coppola = Director("Francis Ford Coppola", war :: Nil)
val wilder  = Director("Billy Wilder", comedies)

import CinemaImplicits.{movieWrites,directorWrites}
val okey = OK(war)
implicit val okwrites = Response.responseWriter[Movie](a => okey.body)
Json.toJson(okey)

Json.toJson(OK(wilder))(Response.responseWriter[Director](a => wilder))
