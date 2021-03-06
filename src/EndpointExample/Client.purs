module EndpointExample.Client where

import Prelude (Unit, unit, pure, show, (<>), ($), bind, void, discard)

import Control.Monad.Eff (Eff, kind Effect)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Exception (message)
import Control.Monad.Aff (runAff)
import Control.Monad.Aff.Endpoint (execEndpoint)

import Network.HTTP.Affjax (AJAX)

import EndpointExample.Model (getOrdersEndpoint)

----------------------------

foreign import data DOM :: Effect
foreign import appendToBody :: forall eff. String -> Eff (dom :: DOM | eff) Unit

main :: forall eff. Eff ( dom :: DOM , ajax :: AJAX | eff ) Unit
main = void $ runAff (\e -> appendToBody $ "Error: " <> message e) (\_ -> appendToBody ("Done!")) do
  ordersForOne <- execEndpoint getOrdersEndpoint 1 unit
  ordersForTwo <- execEndpoint getOrdersEndpoint 2 unit
  liftEff $ appendToBody $ "OrdersForOne: " <> show ordersForOne
  liftEff $ appendToBody $ "OrdersForTwo: " <> show ordersForTwo
  pure unit
