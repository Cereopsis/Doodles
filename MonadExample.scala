package monad

case class Feature[A](param: A) {
  def map[U](f: A => U): Feature[U] = Feature(f(param))
  def flatMap[U](f: A => Feature[U]): Feature[U] = f(param)
}

object Main extends App {

  val m = Feature(100)
  val f = (i: Int) => Feature(s"Hello $i")
  val g = (s: String) => Feature(s.toUpperCase)
  
  val associates = ((m flatMap f) flatMap g) == (m flatMap (x => f(x) flatMap g))
  println(s"Associates? ${associates}")
  
  val leftUnit = (Feature(100) flatMap f) == f(100)
  println(s"Left unit holds? ${leftUnit}")
  
  val rightUnit = (m flatMap Feature.apply _) == m
  println(s"Right unit holds? ${rightUnit}")
 
}
