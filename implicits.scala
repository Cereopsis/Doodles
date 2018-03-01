import scala.concurrent.duration._
import java.time.LocalDateTime

// Define interface for checking expiration
trait Expires[A] {
  def hasExpired(x: A): Boolean
}

// Define the means to construct instance of the trait
object Expires {
  def apply[A:Expires]: Expires[A] = implicitly
}

// Define implementation(s) of the trait

// 1. Session - expires when the timeout is exceeded
implicit object SessionWrapper extends Expires[Session] {
  import scala.concurrent.duration._
  def timeout(implicit period: Duration): Long = period.toSeconds
  def hasExpired(s: Session) =
    s.timestamp.plusSeconds(timeout).compareTo(LocalDateTime.now) < 1
}

// 2. Person - expiration due to death :-(
implicit object PersonWrapper extends Expires[Person] {
  def hasExpired(p: Person): Boolean = p.died.isDefined
}

final case class Session(timestamp: LocalDateTime)
final case class Person(name: String, dob: String, died: Option[String] = None)

// Define the glue that pulls it all together
// Expires[A] constructs the implicit object that implements the trait for the type A
// In the above cases these are the implicit singleton objets
def isValid[A:Expires](x: A) = !Expires[A].hasExpired(x)

implicit val expirationPeriod: Duration = 30 seconds

val session = Session(LocalDateTime.now.minusSeconds(10))
val actress = Person("Alicia Vikander", "1988-10-03")
val poet    = Person("George Gordon Byron", "1788", Some("1824"))

isValid(session) // try this a few times over 20-30 seconds
isValid(actress)
isValid(poet)
