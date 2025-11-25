<?php

namespace Tests\Feature\Api;

use App\Models\Product;
use Tests\TestCase;

class ProductsApiTest extends TestCase
{
    /** @test */
    public function authenticated_user_can_list_products()
    {
        $this->actingAsUser();

        Product::factory()->count(5)->create();

        $response = $this->getJson('/api/products');

        $response->assertStatus(200)
            ->assertJsonCount(5);
    }

    /** @test */
    public function admin_can_create_product_with_valid_data()
    {
        $this->actingAsAdmin();

        $payload = [
            'name'        => 'API Test Product',
            'description' => 'Created in automated test',
            'price'       => 19.99,
            'stock'       => 10,
            'category'    => 'Books',
        ];

        $response = $this->postJson('/api/products', $payload);

        $response->assertStatus(201)
            ->assertJsonFragment([
                'name' => 'API Test Product',
            ]);

        $this->assertDatabaseHas('products', ['name' => 'API Test Product']);
    }

    /** @test */
    public function creating_product_with_invalid_price_returns_validation_error()
    {
        $this->actingAsAdmin();

        $payload = [
            'name'        => 'Invalid Product',
            'description' => 'Invalid price test',
            'price'       => 'abc',
            'stock'       => 5,
            'category'    => 'Toys',
        ];

        $response = $this->postJson('/api/products', $payload);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['price']);
    }

    /** @test */
    public function normal_user_cannot_create_product()
    {
        $this->actingAsUser();

        $payload = [
            'name'        => 'User Product',
            'description' => 'Should not be allowed',
            'price'       => 9.99,
            'stock'       => 3,
            'category'    => 'Toys',
        ];

        $response = $this->postJson('/api/products', $payload);

        $response->assertStatus(403);
    }

    /** @test */
    public function admin_can_update_product()
    {
        $this->actingAsAdmin();

        $product = Product::factory()->create([
            'name' => 'Old Name',
        ]);

        $payload = [
            'name'        => 'New Name',
            'description' => $product->description,
            'price'       => $product->price,
            'stock'       => $product->stock,
            'category'    => $product->category,
        ];

        $response = $this->putJson("/api/products/{$product->id}", $payload);

        $response->assertStatus(200)
            ->assertJsonFragment(['name' => 'New Name']);

        $this->assertDatabaseHas('products', [
            'id'   => $product->id,
            'name' => 'New Name',
        ]);
    }

    /** @test */
    public function normal_user_cannot_update_product()
    {
        $product = Product::factory()->create();

        $this->actingAsUser();

        $payload = [
            'name'        => 'Updated by user',
            'description' => $product->description,
            'price'       => $product->price,
            'stock'       => $product->stock,
            'category'    => $product->category,
        ];

        $response = $this->putJson("/api/products/{$product->id}", $payload);

        $response->assertStatus(403);
    }
}
