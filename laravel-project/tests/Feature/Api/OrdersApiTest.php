<?php

namespace Tests\Feature\Api;

use App\Models\Product;
use App\Models\User;
use Tests\TestCase;
use Laravel\Sanctum\Sanctum;


class OrdersApiTest extends TestCase
{
    /** @test */
    public function user_can_list_their_orders()
    {
        $user = $this->actingAsUser();

        // If you have an Order factory, you can create orders here.
        // Otherwise, create one via API:
        $product = Product::factory()->create(['price' => 10.00]);

        $this->postJson('/api/orders', [
            'items' => [
                ['product_id' => $product->id, 'quantity' => 1],
            ],
        ]);

        $response = $this->getJson('/api/orders');

        $response->assertStatus(200);
        // Optionally assert structure / total count once you know response format.
    }

    /** @test */
    public function user_can_create_order_with_valid_items()
    {
        $this->actingAsUser();

        $product1 = Product::factory()->create(['price' => 10.00]);
        $product2 = Product::factory()->create(['price' => 20.00]);

        $payload = [
            'items' => [
                ['product_id' => $product1->id, 'quantity' => 2],
                ['product_id' => $product2->id, 'quantity' => 1],
            ],
        ];

        $response = $this->postJson('/api/orders', $payload);

        $response->assertStatus(201)
            ->assertJsonStructure([
                'id',
                'status',
                'total_amount',
            ]);
    }

    /** @test */
    public function creating_order_with_empty_items_array_returns_validation_error()
    {
        $this->actingAsUser();

        $payload = ['items' => []];

        $response = $this->postJson('/api/orders', $payload);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['items']);
    }

    /** @test */
    public function admin_can_update_order_status()
    {
        $this->actingAsAdmin();

        $user    = User::factory()->create();
        $product = Product::factory()->create(['price' => 10.00]);

        // Create order via API as that user
        Sanctum::actingAs($user);
        $orderResponse = $this->postJson('/api/orders', [
            'items' => [
                ['product_id' => $product->id, 'quantity' => 1],
            ],
        ]);
        $orderId = $orderResponse->json('id');

        // Switch back to admin to update
        $this->actingAsAdmin();

        $response = $this->putJson("/api/orders/{$orderId}", [
            'status' => 'processing',
        ]);

        $response->assertStatus(200)
            ->assertJsonFragment(['status' => 'processing']);
    }
}
