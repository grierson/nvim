(ns playgroud
  (:require 
    [clojure.string :as str]))

(defn clojure-function [args]
  (let [string "multi\ntring"
        regexp #"regex"
        number 100.000
        booleans [false true]
        keyword ::the-keyword]
    ;; this comment
    (if true
      (->>
        (list [vector] {:map map} #{'set'})))))


;; current line highlight

;; find highlights
(def some-var)
(defonec another-var)
