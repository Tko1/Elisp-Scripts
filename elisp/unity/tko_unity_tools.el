(require 'cl-lib)


<class-default>DrainableStat health(Name="Health",Val = 10, Max_Val = 10)</class-default>



becomes

DrainableStat health;
DrainableStat Health
{
  get
{
  if(health==null) health = gameObject.AddComponent<DrainableStat>
}
}


;; <tag> </tag>
