--- This module contains the SCHEDULER class.
--
-- 1) @{Core.Scheduler#SCHEDULER} class, extends @{Core.Base#BASE}
-- =====================================================
-- The @{Core.Scheduler#SCHEDULER} class models time events calling given event handling functions.
--
-- 1.1) SCHEDULER constructor
-- --------------------------
-- The SCHEDULER class is quite easy to use:
--
--  * @{Core.Scheduler#SCHEDULER.New}: Setup a new scheduler and start it with the specified parameters.
--
-- 1.2) SCHEDULER timer stop and start
-- -----------------------------------
-- The SCHEDULER can be stopped and restarted with the following methods:
--
--  * @{Core.Scheduler#SCHEDULER.Start}: (Re-)Start the scheduler.
--  * @{Core.Scheduler#SCHEDULER.Stop}: Stop the scheduler.
--
-- 1.3) Reschedule new time event
-- ------------------------------
-- With @{Core.Scheduler#SCHEDULER.Schedule} a new time event can be scheduled.
--
-- ===
--
-- ### Contributions: 
-- 
--   * Mechanist : Concept & Testing
-- 
-- ### Authors: 
-- 
--   * FlightControl : Design & Programming
-- 
-- ===
--
-- @module Scheduler


--- The SCHEDULER class
-- @type SCHEDULER
-- @field #number ScheduleID the ID of the scheduler.
-- @extends Core.Base#BASE
SCHEDULER = {
  ClassName = "SCHEDULER",
  Schedules = {},
}

--- SCHEDULER constructor.
-- @param #SCHEDULER self
-- @param #table TimeEventObject Specified for which Moose object the timer is setup. If a value of nil is provided, a scheduler will be setup without an object reference.
-- @param #function TimeEventFunction The event function to be called when a timer event occurs. The event function needs to accept the parameters specified in TimeEventFunctionArguments.
-- @param #table TimeEventFunctionArguments Optional arguments that can be given as part of scheduler. The arguments need to be given as a table { param1, param 2, ... }.
-- @param #number StartSeconds Specifies the amount of seconds that will be waited before the scheduling is started, and the event function is called.
-- @param #number RepeatSecondsInterval Specifies the interval in seconds when the scheduler will call the event function.
-- @param #number RandomizationFactor Specifies a randomization factor between 0 and 1 to randomize the RepeatSecondsInterval.
-- @param #number StopSeconds Specifies the amount of seconds when the scheduler will be stopped.
-- @return #SCHEDULER self
function SCHEDULER:New( TimeEventObject, TimeEventFunction, TimeEventFunctionArguments, StartSeconds, RepeatSecondsInterval, RandomizationFactor, StopSeconds )
  local self = BASE:Inherit( self, BASE:New() )
  self:F2( { StartSeconds, RepeatSecondsInterval, RandomizationFactor, StopSeconds } )

  self:Schedule( TimeEventObject, TimeEventFunction, TimeEventFunctionArguments, StartSeconds, RepeatSecondsInterval, RandomizationFactor, StopSeconds )

  return self
end

--function SCHEDULER:_Destructor()
--  --self:E("_Destructor")
--
--  _TIMERDISPATCHER:RemoveSchedule( self.CallID )
--end

--- Schedule a new time event. Note that the schedule will only take place if the scheduler is *started*. Even for a single schedule event, the scheduler needs to be started also.
-- @param #SCHEDULER self
-- @param #table TimeEventObject Specified for which Moose object the timer is setup. If a value of nil is provided, a scheduler will be setup without an object reference.
-- @param #function TimeEventFunction The event function to be called when a timer event occurs. The event function needs to accept the parameters specified in TimeEventFunctionArguments.
-- @param #table TimeEventFunctionArguments Optional arguments that can be given as part of scheduler. The arguments need to be given as a table { param1, param 2, ... }.
-- @param #number StartSeconds Specifies the amount of seconds that will be waited before the scheduling is started, and the event function is called.
-- @param #number RepeatSecondsInterval Specifies the interval in seconds when the scheduler will call the event function.
-- @param #number RandomizationFactor Specifies a randomization factor between 0 and 1 to randomize the RepeatSecondsInterval.
-- @param #number StopSeconds Specifies the amount of seconds when the scheduler will be stopped.
-- @return #SCHEDULER self
function SCHEDULER:Schedule( TimeEventObject, TimeEventFunction, TimeEventFunctionArguments, StartSeconds, RepeatSecondsInterval, RandomizationFactor, StopSeconds )
  self:F2( { StartSeconds, RepeatSecondsInterval, RandomizationFactor, StopSeconds } )
  self:T3( { TimeEventFunctionArguments } )


  self.TimeEventObject = TimeEventObject
  
  self.Schedules[#self.Schedules+1] = _TIMERDISPATCHER:AddSchedule( 
    self, 
    TimeEventFunction,
    TimeEventFunctionArguments,
    StartSeconds,
    RepeatSecondsInterval,
    RandomizationFactor,
    StopSeconds
  )

  return self
end

--- (Re-)Starts the scheduler.
-- @param #SCHEDULER self
-- @return #SCHEDULER self
function SCHEDULER:Start()
  self:F2()

  if self.RepeatSecondsInterval ~= 0 then
    self.Repeat = true
  end
  
  if self.StartSeconds then
    self:T( { self.StartSeconds } )
    self.Schedules[#self.Schedules+1] = _TIMERDISPATCHER:AddSchedule( 
      self, 
      self.TimeEventObject,
      self.TimeEventFunction,
      self.TimeEventFunctionArguments,
      self.StartSeconds,
      self.RepeatSecondsInterval,
      self.RandomizationFactor,
      self.StopSeconds
    )
  end
  
  return self
end

--- Stops the scheduler.
-- @param #SCHEDULER self
-- @return #SCHEDULER self
function SCHEDULER:Stop()
  self:F2( self.TimeEventObject )

  self.Repeat = false
  if self.ScheduleID then
    self:E( "Stop Schedule" )
    timer.removeFunction( self.ScheduleID )
  end
  self.ScheduleID = nil

  return self
end















