<?php

namespace Tests\Feature\Workflow;

use App\Models\Product;
use Tests\TestCase;

class UserOrderWorkflowTest extends TestCase
{
    /** @test */
    public function user_can_view_products_and_create_order_end_to_end()
    {
        $this->actingAsUser();

        Product::factory()->count(2)->create([
            'price' => 10.00,
        ]);

        // Step 1: list products
        $productsResponse = $this->getJson('/api/products');
        $productsResponse->assertStatus(200);

        $firstProductId = $productsResponse->json('0.id');

        // Step 2: create order
        $orderResponse = $this->postJson('/api/orders', [
            'items' => [
                ['product_id' => $firstProductId, 'quantity' => 2],
            ],
        ]);

        $orderResponse->assertStatus(201)
            ->assertJsonStructure([
                'id',
                'status',
                'total_amount',
            ]);

        $orderId = $orderResponse->json('id');

        // Step 3: verify order appears in GET /api/orders
        $listResponse = $this->getJson('/api/orders');

        $listResponse->assertStatus(200)
            ->assertJsonFragment(['id' => $orderId]);
    }
}
