--
-- A prototyping of data layout/types. Using stock Ada types - arrays, not collections, etc..
-- The goal here is to prototype the use first, especially NNet layout in client programs.
-- Trying to contain all construction solely to a declarative region.
--
-- A basic prototype - no "contained blobs" - connectrons or wahtever. Nnet consisting
-- straight of individual neurons. Still need 2 separate layers though: inputs and outputs.
-- May use this NNet structure for a connectron in later more elaborate models.
--
-- One imprtant feature to try out right here:
-- in addition to weights, each neuron will track the "delay factor".
-- Not yet sure whether to count this delay in steps or do a time-stepped propagation simulation..

-- Copyright (C) 2018  George Shapovalov <gshapovalov@gmail.com>
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
generic
    type Real is digits <>; -- to easily select single/double precision
package generic_proto_nets is

    -- We can have neurons connected to 1. other neurons, 1. inputs or 3. outputs
    -- so we need an abstraction to provide common interface
    type Connector is abstract tagged null record;
    -- could this be an Interface? But we need ponters to these objects..
    type ConnectorPtr is access Connector;
    type ConnArray is array (Positive range <>) of ConnectorPtr;

    -- now the principal part
    type WeightArray is array (Natural range <>) of Real;
    type ActivationFunctionPtr is access function (x : Real) return Real;

    type Neuron(Nin : Positive) is new Connector with record
        inputs : ConnArray(1 .. Nin);
        weight : WeightArray(0 .. Nin);
        activat : ActivationFunctionPtr;
    end record;
    -- NOTE: this is the most straightforward way - to link neurons directly
    -- but this will rely on recursion a lot - as both forward and back propagation
    -- would happen via recursive calls to all linked get_output/get_deriv..
    -- Far from optimal on most common architectures. Need to redesign..

    type NNet is null record;

    ToDo : exception;

    -- specifics
    function sigmoid(x : Real) return Real;
    function reLu   (x : Real) return Real;

end generic_proto_nets;
