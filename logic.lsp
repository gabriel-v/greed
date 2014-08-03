(in-package :greed)
;logic.lsp 
; Here goes the buissness logic of the game

(defclass dice-set ()
  ((vals :reader get-values :type 'list :initform nil)))

(defvar *dice-set* (make-instance 'dice-set))

(defgeneric roll (n set)
  (:documentation 
    "roll the n dice and store the result in the responding class"))

(defmethod get-values ((object dice-set))
  (slot-value object 'vals))

(defmethod roll (how-many (object dice-set))
  (let (vals)
    (dotimes (i how-many)
      (push (1+ (random 6)) vals))
    (setf (slot-value object 'vals) vals)))

(defmethod score ((dice-inst dice-set))
  "returns (values score number-of-remaining-dice)"
  (let ((score 0)
        (dice (get-values dice-inst)))
    (when (>= (count 1 dice) 3)
      (incf score 1000)
      (setf dice (remove 1 dice :count 3)))
    (loop 
      for i from 2 to 6
      when (>= (count i dice) 3)
      do (incf score (* i 100)) and 
      do (setf dice (remove i dice :count 3)))
    (when (< (count 5 dice) 3) 
      (incf score (* (count 5 dice) 50))
      (setf dice (remove 5 dice)))
    (when (< (count 1 dice) 3) 
      (incf score (* (count 1 dice) 100))
      (setf dice (remove 1 dice)))
    (values score (length dice))))  

(defgeneric run-turn (player)
  (:documentation "Run a single turn for a player."))
 
(defmethod run-turn ((pl player))
  (with-slots (state) pl
    (incf (turns state))
    (let ((num-dice 5)
          (hand-score 0)
          (turn-score 0))
      (loop 
        (roll num-dice *dice-set*)
        (multiple-value-setq 
          (hand-score num-dice) 
          (score *dice-set*))
        (when (and (< num-dice 5) (zerop hand-score))
          (incf (turn-lost state))
          (incf (total-lost-score state) turn-score)
          (message-roll-fail turn-score (get-values *dice-set*) pl)
          (return 0))
        (incf turn-score hand-score)
        (unless (get-choice turn-score (get-values *dice-set*) num-dice pl) 
          (incf (turn-wins state))
          (incf (total-turn-score state) turn-score)
          (return turn-score))))))



