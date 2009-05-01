////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//
//  Copyright (c) 2007-2009, Daniel Gasienica <daniel@gasienica.ch>
//
//  OpenZoom is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  OpenZoom is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with OpenZoom. If not, see <http://www.gnu.org/licenses/>.
//
////////////////////////////////////////////////////////////////////////////////
package org.openzoom.flash.descriptors.djatoka
{

import flash.geom.Rectangle;

import flexunit.framework.TestCase;

import org.openzoom.flash.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.flash.descriptors.IMultiScaleImageLevel;

/**
 * Tests the DjatokaDescriptor implementation for correctness.
 */
public class DjatokaDescriptorTest extends TestCase
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const LEVELS:Array =
        [// width, height, columns, rows
            [   38,    57,       1,    1 ],
            [   76,   113,       1,    1 ],
            [  151,   226,       1,    1 ],
            [  302,   452,       2,    2 ],
            [  604,   903,       3,    4 ],
            [ 1208,  1805,       5,    8 ],
            [ 2416,  3610,      10,   15 ],
        ]

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var descriptor:IMultiScaleImageDescriptor

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: TestCase
    //
    //--------------------------------------------------------------------------

    override public function setUp():void
    {
        descriptor = new DjatokaDescriptor("",
                                            "http://farm4.static.flickr.com/3187/2780115722_20d8d18d33_o.jpg",
                                            2416,
                                            3610,
                                            256,
                                            0,
                                            "image/jpeg")
    }

    override public function tearDown():void
    {
        descriptor = null
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Tests
    //
    //--------------------------------------------------------------------------

    public function testMaxLevel():void
    {
        assertEquals("Maximum level correctly computed", 6, descriptor.numLevels - 1)
    }

    public function testOverlap():void
    {
        assertEquals("Overlap correct", 0, descriptor.tileOverlap)
    }

    public function testLevels():void
    {
       for (var index:int = 0; index < descriptor.numLevels; index++)
       {
              var level:IMultiScaleImageLevel = descriptor.getLevelAt(index)
           assertEquals("Width on level "        + level.index, LEVELS[ level.index ][ 0 ], level.width)
           assertEquals("Height on level "       + level.index, LEVELS[ level.index ][ 1 ], level.height)
           assertEquals("Column count on level " + level.index, LEVELS[ level.index ][ 2 ], level.numColumns)
           assertEquals("Row count on level "    + level.index, LEVELS[ level.index ][ 3 ], level.numRows)
       }

    }

    public function testGetMinimumLevelForSize():void
    {
       assertEquals("Level computation for given size", descriptor.numLevels - 1,
           descriptor.getMinLevelForSize(descriptor.width, descriptor.height).index)

       assertEquals("Level computation for given size", descriptor.numLevels - 2,
           descriptor.getMinLevelForSize(descriptor.width / 2 - 1, descriptor.height / 2 - 1).index)
    }

    public function testTileBounds():void
    {
        for (var index:int = 0; index < descriptor.numLevels; index++)
        {
            var level:IMultiScaleImageLevel = descriptor.getLevelAt(index)
            var computedBounds:Rectangle = new Rectangle()

            for (var column:uint = 0; column < level.numColumns; column++)
            {
                for (var row:uint = 0; row < level.numRows; row++)
                {
                    var tileBounds:Rectangle = level.getTileBounds(column, row)
                    computedBounds = computedBounds.union(tileBounds)
                }

            }

            var bounds:Rectangle = new Rectangle(0, 0, level.width, level.height)
            assertTrue("Level bounds must match", computedBounds.equals(bounds))
        }
    }
}

}

