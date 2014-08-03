(in-package :greed)

(defclass ai (player) 
  ((difficulty :reader get-difficulty 
              :initform (error "Set difficulty 1-10")
              :initarg :difficulty)))

(defmethod message-roll-fail (score dice (player ai))
  nil)

(defmethod get-choice (turn-score dice num-dice (player ai))
  "TODO: the decision algorithm. The output is a t/nil answer, based on: Current turn score, dice."
  (zerop (random 3)))
