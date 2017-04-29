
import play.api.libs.json.{Json,JsValue,Writes,Reads}

sealed trait Response
case class ErrorResponse(code: Int, reason: String) extends Response

object ErrorResponse {
  val InternalServerError = ErrorResponse(500, "Internal Server Error")
  val NotFound = ErrorResponse(404, "Not Found")
  implicit val errorWrites = Json.writes[ErrorResponse]
}

case class OK[+A](body: A) extends Response {
  val code = 200
}

object OK {
  implicit def okWriter[A](implicit w: Writes[A]): Writes[OK[A]] = new Writes[OK[A]]{
    override def writes(o: OK[A]): JsValue = Json.obj(
      "code" -> o.code,
      "body" -> o.body
    )
  }
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
Json.toJson(OK(war))
Json.toJson(OK(comedies))
Json.toJson(OK(wilder))

import ErrorResponse.{InternalServerError,NotFound}
Json.toJson(InternalServerError)
Json.toJson(NotFound)
